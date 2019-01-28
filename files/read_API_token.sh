#!/bin/bash

grep apiToken /tmp/setup-all.out | jq .data.apiToken | tr -d \"
