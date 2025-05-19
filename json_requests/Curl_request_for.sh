#!/bin/bash

curl -v -X GET -H "Content-Type: application/json" --data @$2 http://localhost:8080/port_schedule/$1
