#!/bin/bash

DATADIR="/var/lib/postgresql/9.4/main"
CONF="/etc/postgresql/9.4/main/postgresql.conf"
POSTGRES="/usr/lib/postgresql/9.4/bin/postgres"
INITDB="/usr/lib/postgresql/9.4/bin/initdb"

# test if DATADIR is existent
if [ ! -d $DATADIR ]; then
  echo "Creating Postgres data at $DATADIR"
  mkdir -p $DATADIR
fi

# test if DATADIR has content
#if [ ! "$(ls -A $DATADIR)" ]; then
echo "Initializing Postgres Database at $DATADIR"
chown -R postgres $DATADIR
su postgres sh -c "$INITDB $DATADIR"
#echo "Create user"
su postgres sh -c "$POSTGRES --single -D $DATADIR -c config_file=$CONF" <<< "CREATE USER osm WITH SUPERUSER PASSWORD 'openstreetmap';"
#echo "Create database"
#su postgres sh -c "$POSTGRES --single -D $DATADIR -c config_file=$CONF" <<< "CREATE DATABASE osm WITH OWNER = osm;"


#fi

if [ ! -d "/style/data" ];then
	sh -c "/style/get-shapefiles.sh"
fi
trap "echo \"Sending SIGTERM to postgres\"; killall -s SIGTERM postgres" SIGTERM
su postgres sh -c "uwsgi --http :8080 --eval 'import TileStache; application = TileStache.WSGITileServer(\"/mapserver.cfg\")'" &
su postgres sh -c "$POSTGRES -D $DATADIR -c config_file=$CONF" &
sleep 5
#su postgres sh -c "createdb --encoding=UTF8 --owner=osm osm"
su postgres sh -c "psql -c \"CREATE DATABASE osm WITH TEMPLATE = template0 ENCODING 'UTF8' OWNER = osm;\" "
su postgres sh -c "psql -d osm -c\"CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;\" "
wait $!



