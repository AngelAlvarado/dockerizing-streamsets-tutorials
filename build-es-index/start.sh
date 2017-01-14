#/bin/sh

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
   echo "Creating ElasticSearch cclogs index"
   curl -XPUT 'elasticsearch:9200/cclogs' -d '{"mappings":{"cclogs":{"properties":{"transaction_date":{"type":"date"},"card_expiry_date":{"type":"string","index":"not_analyzed"},"card_number":{"type":"string","index":"not_analyzed"},"card_security_code":{"type":"integer","index":"not_analyzed"},"description":{"type":"string","index":"not_analyzed"},"purchase_amount":{"type":"integer","index":"not_analyzed"}}}}}'
   ElasticActive=1
 elif [ $isESactive -eq 0 -a $isLogsIndex -eq 0 ]
  then
   echo "cclogs index already in ElasticSearch"
   ElasticActive=1
 else
   echo "Trying to insert ElasticSearch logs Index"
 fi
done
