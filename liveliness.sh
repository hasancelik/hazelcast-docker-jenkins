#!/bin/bash

host=$1
if [ -z "$1" ]
  then
    host=localhost
fi

URL="http://$host:5701/hazelcast/healthcheck"
echo $URL

HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" $URL)
HTTP_BODY=$(echo $HTTP_RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

if [ ! $HTTP_STATUS -eq 200  ]; then
  echo "failure, http status: "$HTTP_STATUS
  exit 1
fi

result=$(echo $HTTP_BODY | awk '{match($0,  /Hazelcast\:\:NodeState\=([A-Z]*)/, m)}END{print m[1]}')
if [ "$result" == "SHUT_DOWN" ]; then exit 1; else exit 0; fi
