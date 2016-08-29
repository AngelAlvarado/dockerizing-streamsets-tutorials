#!/bin/sh
curl -XPUT 'http://localhost:9200/logs' -d '{
    "mappings": {
        "logs" : {
            "properties" : {
                "timestamp": {"type": "date"},
                "geo": {"type": "geo_point"},
                "city": {
                    "type": "string",
                "index": "not_analyzed"
                }
            }
        }
    }
}'
