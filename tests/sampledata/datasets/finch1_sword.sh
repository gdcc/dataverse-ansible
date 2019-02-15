#!/bin/sh

USERDIR=/vagrant/tests/sampledata/users/out
DATASETDIR=/vagrant/tests/sampledata/datasets

APITOKEN=$1
FINCHKEY=`cat $USERDIR/finch.user | jq .data.apiToken | tr -d \"`

echo "finch should be an admin of the finches dataverse."
curl -s -X POST -H "Content-type:application/json" -d "{\"assignee\": \"@finch\",\"role\": \"admin\"}" "http://localhost:8080/api/dataverses/finches/assignments?key=$APITOKEN"

echo "creating finch1 dataset via SWORD API"
curl -s -X POST -H "Content-type:application/json" -H "X-Dataverse-key: $FINCHKEY" "http://localhost:8080/api/dataverses/finches/datasets" --upload-file $DATASETDIR/dataset-finch1.json
