#!/bin/sh

USERDIR=../users/out

APITOKEN=$1
FINCHKEY=`cat $USERDIR/finch.user | jq .data.apiToken | tr -d \"`

# expects sampledataset dir as 2nd argument
cd $2

echo "make finch an admin of the finches dataverse."
curl -s -X POST -H "Content-type:application/json" -d "{\"assignee\": \"@finch\",\"role\": \"admin\"}" "http://localhost:8080/api/dataverses/finches/assignments?key=$APITOKEN"

echo "creating finch1 dataset via SWORD API"
curl -s -X POST -H "Content-type:application/json" -H "X-Dataverse-key: $FINCHKEY" "http://localhost:8080/api/dataverses/finches/datasets" --upload-file dataset-finch1.json

echo "creating finch2 dataset via SWORD API"
curl -s -X POST -H "Content-type:application/json" -H "X-Dataverse-key: $FINCHKEY" "http://localhost:8080/api/dataverses/finches/datasets" --upload-file dataset-finch2.json
