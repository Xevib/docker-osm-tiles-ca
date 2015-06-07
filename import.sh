#!/bin/bash
su postgres sh -c "wget http://download.geofabrik.de/europe/spain-latest.osm.bz2 -O ./root/osm_data/osm/spain-latest.osm.bz2"
su postgres sh -c "bzip2 -d ./root/osm_data/osm/spain-latest.osm.bz2"
su postgres sh -c "osm2pgsql -c -d osm -s  --drop /root/osm_data/osm/spain-latest.osm"
