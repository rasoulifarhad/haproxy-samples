#!/bin/bash
# 
stop_servers()  {

     for node in "${NODES[@]}"
       do
          num=$((scale))
          while [[ ${num} -ge 1 ]]
          do
             echo "stoping ${node}-node${num} "
             docker stop "${node}-node${num}"
             
             echo "removing ${node}-node${num} "
             docker rm "${node}-node${num}"
             
             num=$((num-1))
          done
       done
}  
declare -a NODES=("bank-server")

scale=2
  
stop_servers
  

