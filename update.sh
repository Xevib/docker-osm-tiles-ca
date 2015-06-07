#!/bin/bash
mkdir /osm
set pgpassword=openstreetmap
wget http://download.geofabrik.de/europe/spain-latest.osm.bz2 -O /osm/spain-latest.osm.bz2
bzip2 -d /osm/spain-latest.osm.bz2
chown postgres /osm/spain-latest.osm
su postgres sh -c "PGPASS=openstreetmap osm2pgsql -c -d osm -s  --drop /osm/spain-latest.osm -H localhost -U osm"
