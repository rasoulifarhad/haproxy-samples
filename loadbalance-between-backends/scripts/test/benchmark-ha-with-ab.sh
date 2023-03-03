#!/bin/bash
# 
ulimit -n 10000
ab -c 2500 -n 5000 -s 90 http://localhost/
# ab -q -d -S  -c 2500 -n 5000 -s 90 http://localhost/
