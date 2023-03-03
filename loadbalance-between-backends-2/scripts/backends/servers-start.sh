#!/bin/bash
# 
start_servers() {

     for nodeIndex in "${!NODES[@]}"
       do
          node="${NODES[$nodeIndex]}"
          rport="${NODE_PORTS[$nodeIndex]}"
          num=$((scale))
          while [[ ${num} -ge 1 ]]
          do
             echo "starting: ${node}-node${num} port: ${exposedPortStart} "
             docker run -d --name "${node}-node${num}" --net server-network -p "${exposedPortStart}:${rport}" --privileged hashicorp/http-echo:latest  -listen=:"${rport}" -text="This is HTTP Echo server ${node}-node${num} "
             num=$((num-1))
             exposedPortStart=$((exposedPortStart+1))
          done
       done
}  
declare -a NODES=("bank-server")
declare -a NODE_PORTS=(8080 )

scale=2
exposedPortStart=1234
  
start_servers
  

