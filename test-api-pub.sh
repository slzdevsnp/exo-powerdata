#!/usr/bin/env bash

#
# Sample usage:
#
#   HOST=localhost PORT=7000 ./test-em-all.bash
#
: ${HOST=localhost}
: ${PORT=8080}

function assertCurl() {

  local expectedHttpCode=$1
  local curlCmd="$2"
  local result=$(eval "$curlCmd -w %{http_code}")
  local httpCode="${result:(-3)}"
  RESPONSE='' && (( ${#result} > 3 )) && RESPONSE="${result%???}"

  if [ "$httpCode" = "$expectedHttpCode" ]
  then
    if [ "$httpCode" = "200" ]
    then
      echo "Test OK (HTTP Code: $httpCode)"
    else
      echo "Test OK (HTTP Code: $httpCode, $RESPONSE)"
    fi
  else
      echo  "Test FAILED, EXPECTED HTTP Code: $expectedHttpCode, GOT: $httpCode, WILL ABORT!"
      echo  "- Failing command: $curlCmd"
      echo  "- Response Body: $RESPONSE"
      exit 1
  fi
}

function assertEqual() {

  local expected=$1
  local actual=$2

  if [ "$actual" = "$expected" ]
  then
    echo "Test OK (actual value: $actual)"
  else
    echo "Test FAILED, EXPECTED VALUE: $expected, ACTUAL VALUE: $actual, WILL ABORT"
    exit 1
  fi
}
set -e

echo "HOST=${HOST}"
echo "PORT=${PORT}"

cob=20250325
asset=Nendaz
provider="provider-A"
sdate1="2025-03-27T00:00:00Z"
edate1="2025-03-27T03:00:00Z"

epoint=/forecast/${cob}

# upload
query_upld="http://localhost:8080/forecast/20250325?provider=provider-A"
echo "uploading with POST $query_upld"
curl -s -X POST "$query_upld"

query_upld="http://localhost:8080/forecast/20250325?provider=provider-B"
echo "uploading with POST $query_upld"
curl -s -X POST "$query_upld"


# Verify that a normal retrieve request works, check http code and some data
# tests below assume a returned payload as json {"data":[{ "datetime":"2025-03-27T00:00:00Z","powerMw":13.241},{..}]}

query="http://$HOST:$PORT${epoint}?asset=$asset&start_datetime=$sdate1&end_datetime=$edate1&provider=$provider"
echo "testing on api query: $query"
assertCurl 200 'curl -s $query'

assertEqual 0 $(echo $RESPONSE | jq -r .data[0].powerMw)
assertEqual 0 $(echo $RESPONSE | jq -r .data[1].powerMw)
assertEqual 13.24 $(echo $RESPONSE | jq -r .data[2].powerMw)

# Verify that a normal retrieve request works, check http code and some data
query="http://$HOST:$PORT${epoint}?asset=$asset&start_datetime=$sdate1&end_datetime=$edate1"
echo "testing on api query: $query"
assertCurl 200 'curl -s $query'

assertEqual 13.241 $(echo $RESPONSE | jq -r .data[0].powerMw)
assertEqual 13.241 $(echo $RESPONSE | jq -r .data[1].powerMw)
assertEqual 13.24 $(echo $RESPONSE | jq -r .data[2].powerMw)


