#!/bin/bash
# 
#   
docker stop haproxy
echo    "" 
echo "haproxy stoped"
echo    "" 
docker rm haproxy
echo    "" 
echo "container haproxy removed"
echo    "" 


