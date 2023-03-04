#!/bin/bash
# 
ulimit -n 10000
ab -c 2500 -n 5000 -s 90 http://localhost/
# ab -q -d -S  -c 2500 -n 5000 -s 90 http://localhost/
# ab -S -p post_smaller.txt -T application/json -q -n 100000 -c 3000 http://localhost:80/

