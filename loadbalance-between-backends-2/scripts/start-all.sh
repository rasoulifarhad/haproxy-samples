#!/bin/bash
# 
#   
sh -c 'cd net && ./network-create.sh'

sh -c 'cd backends && ./servers-start.sh'
 
sh -c 'cd haproxy && ./ha-start.sh'





