#!/bin/bash

# apitoken should be 1st argument
API_TOKEN=$1

# samplefiles dir should be 2nd argument
FILESDIR=$2

# hard-code files to datasets. only sampledata, after all.
# i started with an associative array, but, eh.

curl -H "X-Dataverse-key:$API_TOKEN" -X POST -F 'file=@120745.dta' -F 'jsonData={"description":"Data file","categories":["Data"], "restrict":"true"}' "http://localhost:8080/api/datasets/9/add"
sleep 3
curl -H "X-Dataverse-key:$API_TOKEN" -X POST -F 'file=@1char' -F 'jsonData={"description":"1-char file","categories":["Data"], "restrict":"true"}' "http://localhost:8080/api/datasets/9/add"
sleep 3
curl -H "X-Dataverse-key:$API_TOKEN" -X POST -F 'file=@50by1000.dta' -F 'jsonData={"description":"50x1000 datafile.","categories":["Data"], "restrict":"true"}' "http://localhost:8080/api/datasets/9/add"
sleep 3
curl -H "X-Dataverse-key:$API_TOKEN" -X POST -F 'file=@50by1000.dta.zip' -F 'jsonData={"description":"50x1000 data zipfile.","categories":["Data"], "restrict":"true"}' "http://localhost:8080/api/datasets/9/add"
sleep 3
curl -H "X-Dataverse-key:$API_TOKEN" -X POST -F 'file=@open-source-at-harvard118.dta' -F 'jsonData={"description":"Open Source at Harvard","categories":["Data"], "restrict":"true"}' "http://localhost:8080/api/datasets/10/add"
sleep 3
curl -H "X-Dataverse-key:$API_TOKEN" -X POST -F 'file=@stata13-auto.dta' -F 'jsonData={"description":"Stata 13 Datafile","categories":["Data"], "restrict":"true"}' "http://localhost:8080/api/datasets/10/add"
sleep 3
curl -H "X-Dataverse-key:$API_TOKEN" -X POST -F 'file=@stata13-auto-withstrls.dta' -F 'jsonData={"description":"Stata 13 Datafile with strls","categories":["Data"], "restrict":"true"}' "http://localhost:8080/api/datasets/10/add"
sleep 3
curl -H "X-Dataverse-key:$API_TOKEN" -X POST -F 'file=@stata14-auto-withstrls.dta' -F 'jsonData={"description":"Stata 14 Datafile with strls","categories":["Data"], "restrict":"true"}' "http://localhost:8080/api/datasets/10/add"
