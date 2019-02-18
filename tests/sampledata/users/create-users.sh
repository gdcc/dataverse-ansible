#!/bin/sh

SERVER='http://localhost:8080/api'
BURRITO='burrito'

for i in `cd $1 && ls -1 *.user`; do
  echo $i
  pass=`cat $i | jq .userName | tr -d \"`
  echo $pass
  resp=$(curl -s -H "Content-type:application/json" -X POST -d @$i "$SERVER/builtin-users?password=$pass&key=$BURRITO")
  mkdir -p out
  echo $resp
  echo $resp | jq . > out/$i
done
