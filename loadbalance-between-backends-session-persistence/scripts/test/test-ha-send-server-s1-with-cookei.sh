#!/bin/bash
# 
testDir=$(cd $(dirname "${BASH_SOURCE:-$0}") && pwd)
scriptsDir=$(dirname "$testDir")
projectBaseDir=$(dirname "$scriptsDir")

PORT=80
HA_HOST="localhost"
PROTO="http://"
#-L, --location follow redirects
#-s : Avoid showing progress bar
#-D - : Dump headers to a file, but - sends it to stdout
#-o /dev/null : Ignore response body
#verbose_flag=" -v -L -s -S "
CURL='/usr/bin/curl'
SERVER_CHOOSE_COOKIE='--cookie "SERVERID=s1"'

test_ha() {
          $CURL --cookie "SERVERID=s1" http://"${HA_HOST}":"${PORT}" 
}  

echo ""
echo "Starting......."
echo ""
echo "This test continuously sends requests to the server" 
echo "with an interval of one second between them ."
echo ""
echo "Requests are sent to the haproxy http frontend address "
echo "on port $PORT , with cookie $SERVER_CHOOSE_COOKIE "
echo ""
echo "     "  http://"${HA_HOST}":"${PORT}"
echo ""
while true; do test_ha; sleep 1; done

