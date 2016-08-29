#/bin/sh

cd /build
tuch bashfile
ping -c 30 localhost > test.txt
sh /start
curl -XPUT 'http://elasticsearch:9200/logs' -d '{"mappings": {"logs" : {"properties" : {"timestamp":{"type": "date"},"geo": {"type": "geo_point"},"city": {"type": "string","index": "not_analyzed"}}}}}


