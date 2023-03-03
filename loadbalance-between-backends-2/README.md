## Run
#
# 1. Run backend servers and haproxy
#
#   Go to scripts folder and execute start-all.sh function 
#
#      cd scripts
#      ./start-all.sh
#
## 2. Test
#
#  Go to test folder and run test-ha.sh function
#
#      cd scripts/test
#      ./test-ha.sh
#
#  You must see :
#
#    Starting.......
#    
#    This test continuously sends requests to the server
#    with an interval of one second between them .
#    
#    Requests are sent to the haproxy http frontend address 
#    on port 80 .
#    
#          http://localhost:80
#   
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#       ...
#        
#    


