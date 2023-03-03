#!/bin/bash
# 
# 
sh -c 'cd haproxy && ./ha-stop.sh'

sh -c 'cd backends && ./servers-stop.sh'

sh -c 'cd net && ./network-remove.sh'

