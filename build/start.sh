#/bin/sh

cd /build
sh /start
curl -XPUT 'http://elasticsearch:9200/logs' -d '{"mappings": {"logs" : {"properties" : {"timestamp":{"type": "date"},"geo": {"type": "geo_point", "geohash": true},"city": {"type": "string","index": "not_analyzed"}}}}}'



