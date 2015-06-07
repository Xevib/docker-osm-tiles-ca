#!/usr/bin/python
import sys
import TileStache

application = TileStache.WSGITileServer('/mapserver.cfg', autoreload=True)
