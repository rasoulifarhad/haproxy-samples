#!/bin/bash
# 
#   
echo "starting haproxy "
VERSION=2.6.6
haproxyDir=$(cd $(dirname "${BASH_SOURCE:-$0}") && pwd)
scriptsDir="$(dirname "$haproxyDir")"
projectBaseDir="$(dirname "$scriptsDir")"

echo $projectBaseDir
docker run -d --name haproxy --ulimit nofile=4000150:4000150 --net server-network --expose 5555  -v ${projectBaseDir}/config:/usr/local/etc/haproxy:rw  -p 5555:5555 -p 80:80 -p 443:443 -p 8404:8404 -p 8397:8397 --privileged -p 9999:9999 haproxytech/haproxy-debian:${VERSION}

docker exec haproxy  /bin/bash -c '
  echo "net.ipv4.tcp_rmem=4096 4096 16777216" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_wmem=4096 4096 16777216" >> /etc/sysctl.conf
  echo "net.ipv4.ip_local_port_range=1024 65535" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_max_syn_backlog=100000" >> /etc/sysctl.conf
  echo "net.core.somaxconn=100000" >> /etc/sysctl.conf
  echo "vm.max_map_count=262144" >> /etc/sysctl.conf
  echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
  echo "fs.file-max=10000000" >> /etc/sysctl.conf
  echo "fs.nr_open=10000000" >> /etc/sysctl.conf
  sysctl -p
  '
  
echo    "" 
echo    "You can access the servers web application at: "
echo    "" 
echo    "   bank-server:" 
echo    "     - https://localhost:443/" 
echo    "" 
echo    "" 
echo    "Each request to it will be load balanced by HAProxy."
echo    "" 
echo    "Also, you can see the HAProxy Stats page at https://localhost:8404/haproxy_stats"
echo    "user:admin        pass:admin" 
echo    ""
echo    "" 
echo    "If you make a change to your haproxy.cfg file, "
echo    "" 
echo    "you can reload the load balancer—without disrupting traffic—by calling the docker kill command:"
echo    "" 
echo    "docker kill -s HUP haproxy"
echo    "" 
echo    "" 

docker logs --follow haproxy
