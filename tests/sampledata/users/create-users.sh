#!/usr/bin/sh

SERVER='http://localhost:8080/api'
BURRITO='burrito'
USERDIR='/vagrant/tests/sampledata/users'

for i in `cd $USERDIR && ls -1 *.user`; do
  echo $i
  pass=`cat $USERDIR/$i | jq .userName | tr -d \"`
  echo $pass
  resp=$(curl -s -H "Content-type:application/json" -X POST -d @$USERDIR/$i "$SERVER/builtin-users?password=$pass&key=$BURRITO")
  mkdir -p $USERDIR/out
  echo $resp
  echo $resp | jq . > $USERDIR/out/$i
done
