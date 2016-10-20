#/bin/sh

cd /build
sleep 15
echo "Creating ElasticSearch index"
ElasticActive=0
while [ $ElasticActive -eq 0 ]
do
 wget elasticsearch:9200 -O - > /bin/null
 isESactive=$?
 wget elasticsearch:9200/logs -O - > /bin/null
 isLogsIndex=$?
 if [ $isESactive -eq 0 -a $isLogsIndex -ne 0 ]
  then
   echo "Creating ElasticSearch logs index"
   curl -XPUT 'elasticsearch:9200/logs' -d '{"mappings": {"logs" : {"properties" : {"auth":{"type":"string"},"bytes":{"type":"long"},"clientip":{"type":"string"}, "httpversion":{"type":"string"}, "ident":{"type":"string"},"request":{"type":"string"},"response":{"type":"long"},"timestamp":{"type": "date"},"verb":{"type":"string"},"geo": {"type": "geo_point", "geohash": true},"city": {"type": "string","index": "not_analyzed"}}}}}'
   ElasticActive=1
 elif [ $isESactive -eq 0 -a $isLogsIndex -eq 0 ]
  then
   echo "logs index already in ElasticSearch"
   ElasticActive=1
 else
   echo "Trying to insert ElasticSearch logs Index"
 fi
done

echo "Creating Kibana index pattern"
KibanaActive=0
while [ $KibanaActive -eq 0 ]
do
 wget kibana:5601 -O - > /bin/null
 isKibanaActive=$?
 # wget elasticsearch:9200/.kibana -O - > /bin/null
 curl -XGET 'elasticsearch:9200/.kibana/_search?size=10' -d '{"query": { "match_all": {}}, "_source": ["index-pattern"] }' | grep "logs"
 isKibanaIndex=$?
 if [ $isKibanaActive -eq 0 -a $isKibanaIndex -ne 0 ]
  then
   echo "Inserting logs index-pattern, dashboard and visualizations"
   curl -XPUT 'kibana:5601/elasticsearch/.kibana/index-pattern/logs?op_type=create' -H "kbn-version: 4.5.4" -H "Content-Type: application/json" -d '{"title":"logs"}'
   curl -XPUT 'elasticsearch:9200/.kibana/config/4.5.4?pretty' -d '{"defaultIndex": "logs"}'
   # Make sure correct mapping is used for dashboards: https://discuss.elastic.co/t/discover-tab-wont-load-anymore/38549/24
   curl -XPUT 'elasticsearch:9200/.kibana/_mapping/dashboard' -d '{"dashboard":{"properties":{"description":{"type":"string"},"hits":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}},"panelsJSON":{"type":"string"},"timeRestore":{"type":"boolean"},"title":{"type":"string"},"version":{"type":"integer"}}}}'
   curl -XPUT 'elasticsearch:9200/.kibana/dashboard/ApacheWeblog-Dashboard?pretty' -d '{"title":"ApacheWeblog Dashboard","hits":0,"description":"","panelsJSON":"[{\"col\":4,\"id\":\"DateCount\",\"row\":1,\"size_x\":9,\"size_y\":2,\"type\":\"visualization\"},{\"col\":1,\"id\":\"Total-Hits\",\"row\":1,\"size_x\":3,\"size_y\":2,\"type\":\"visualization\"},{\"col\":1,\"id\":\"HTTPVerbs\",\"row\":3,\"size_x\":3,\"size_y\":2,\"type\":\"visualization\"},{\"col\":4,\"id\":\"ResponseCodes\",\"row\":3,\"size_x\":3,\"size_y\":2,\"type\":\"visualization\"},{\"col\":5,\"id\":\"Top10Cities\",\"row\":5,\"size_x\":3,\"size_y\":3,\"type\":\"visualization\"},{\"col\":1,\"id\":\"MapView\",\"row\":5,\"size_x\":4,\"size_y\":3,\"type\":\"visualization\"},{\"id\":\"BytesHistogram\",\"type\":\"visualization\",\"size_x\":6,\"size_y\":2,\"col\":7,\"row\":3}]","version":1,"timeRestore":false,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"filter\":[{\"query\":{\"query_string\":{\"analyze_wildcard\":true,\"query\":\"*\"}}}]}"}}'
   curl -XPUT 'elasticsearch:9200/.kibana/visualization/ResponseCodes?pretty' -d '{"title":"ResponseCodes","visState":"{\"type\":\"pie\",\"params\":{\"shareYAxis\":true,\"addTooltip\":true,\"addLegend\":true,\"isDonut\":false},\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"terms\",\"schema\":\"segment\",\"params\":{\"field\":\"response\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"1\"}}],\"listeners\":{}}","description":"","version":1,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"index\":\"logs\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"}}'
   curl -XPUT 'elasticsearch:9200/.kibana/visualization/DateCount?pretty' -d '{"title":"DateCount","visState":"{\"type\":\"histogram\",\"params\":{\"shareYAxis\":true,\"addTooltip\":true,\"addLegend\":true,\"scale\":\"linear\",\"mode\":\"stacked\",\"times\":[],\"addTimeMarker\":false,\"defaultYExtents\":false,\"setYExtents\":false,\"yAxis\":{}},\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"date_histogram\",\"schema\":\"segment\",\"params\":{\"field\":\"timestamp\",\"interval\":\"h\",\"customInterval\":\"2h\",\"min_doc_count\":1,\"extended_bounds\":{}}}],\"listeners\":{}}","description":"","version":1,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"index\":\"logs\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"}}'
   curl -XPUT 'elasticsearch:9200/.kibana/visualization/MapView?pretty' -d '{"title":"MapView","visState":"{\"type\":\"tile_map\",\"params\":{\"mapType\":\"Scaled Circle Markers\",\"isDesaturated\":true,\"heatMaxZoom\":16,\"heatMinOpacity\":0.1,\"heatRadius\":25,\"heatBlur\":15,\"heatNormalizeData\":true,\"addTooltip\":true},\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"geohash_grid\",\"schema\":\"segment\",\"params\":{\"field\":\"geo\",\"autoPrecision\":true,\"precision\":2}}],\"listeners\":{}}","description":"","version":1,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"index\":\"logs\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"}}'
   curl -XPUT 'elasticsearch:9200/.kibana/visualization/BytesHistogram?pretty' -d '{"title":"BytesHistogram","visState":"{\"type\":\"histogram\",\"params\":{\"shareYAxis\":true,\"addTooltip\":true,\"addLegend\":true,\"scale\":\"linear\",\"mode\":\"stacked\",\"times\":[],\"addTimeMarker\":false,\"defaultYExtents\":false,\"setYExtents\":false,\"yAxis\":{}},\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"histogram\",\"schema\":\"segment\",\"params\":{\"field\":\"bytes\",\"interval\":20,\"extended_bounds\":{}}}],\"listeners\":{}}","description":"","version":1,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"index\":\"logs\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"}}'
   curl -XPUT 'elasticsearch:9200/.kibana/visualization/Total-Hits?pretty' -d '{"title":"Total Hits","visState":"{\"type\":\"metric\",\"params\":{\"fontSize\":60},\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}}],\"listeners\":{}}","description":"","version":1,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"index\":\"logs\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"}}'
   curl -XPUT 'elasticsearch:9200/.kibana/visualization/HTTPVerbs?pretty' -d '{"title":"HTTPVerbs","visState":"{\"type\":\"pie\",\"params\":{\"shareYAxis\":true,\"addTooltip\":true,\"addLegend\":true,\"isDonut\":false},\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"terms\",\"schema\":\"segment\",\"params\":{\"field\":\"verb\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"1\"}}],\"listeners\":{}}","description":"","version":1,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"index\":\"logs\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"}}'
   curl -XPUT 'elasticsearch:9200/.kibana/visualization/Top10Cities?pretty' -d '{"title":"Top10Cities","visState":"{\"type\":\"table\",\"params\":{\"perPage\":10,\"showPartialRows\":false,\"showMeticsAtAllLevels\":false},\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"terms\",\"schema\":\"bucket\",\"params\":{\"field\":\"city\",\"size\":10,\"order\":\"desc\",\"orderBy\":\"1\"}}],\"listeners\":{}}","description":"","version":1,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"index\":\"logs\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"}}'
   KibanaActive=1
 elif [ $isKibanaActive -eq 0 -a $isKibanaIndex -eq 0 ]
  then
   echo "Logs index pattern already in ElasticSearch"
   KibanaActive=1
 else
   echo "Trying to insert logs index-pattern, dashboard and visualizations"
 fi
done

while true; do sleep 1000; done #todo remove this line

