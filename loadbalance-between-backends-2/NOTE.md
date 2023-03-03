####  From https://www.cloudbees.com/blog/performance-tuning-haproxy
#
## Basic HAProxy Config
#  
#  In order to set up HAProxy to load balance HTTP traffic across two backend systems, we will first need to modify HAProxy's 
#  default configuration file /etc/haproxy/haproxy.cfg.
#  
#  To get started, we will be setting up a basic frontend service within HAProxy. We will do this by appending the below 
#  configuration block.
#  
#  frontend www
#      bind               :80
#      mode               http
#      default_backend    bencane.com
#      
#  In this section, we are defining a frontend service for HAProxy. This is essentially a frontend listener that will accept 
#  incoming traffic. The first parameter we define within this section is the bind parameter. This parameter is used to tell 
#  HAProxy what IP and Port to listen on; 0.0.0.0:80 in this case. This means our HAProxy instance will listen for traffic on 
#  port 80 and route it through this frontend service named www.
#      
#  Within this section, we are also defining the type of traffic with the mode parameter. This parameter accepts tcp or http 
#  options. Since we will be load balancing HTTP traffic, we will use the http value. The last parameter we are defining is 
#  default_backend, which is used to define the backend service HAProxy should load balance to. In this case, we will use a 
#  value of bencane.com which will route traffic through our NGINX instances.
#  
#  
#  backend bencane.com
#      mode     http
#      balance  roundrobin
#      server   nyc2 nyc2.bencane.com:80 check
#      server   sfo1 sfo1.bencane.com:80 check
#      
#  Like the frontend service, we will also need to define our backend service by appending the above configuration block to the 
#  same /etc/haproxy/haproxy.cfg file.
#  
#  In this backend configuration block, we are defining the systems that HAProxy will load balance traffic to. Like the frontend 
#  section, this section also contains a mode parameter to define whether these are tcp or http backends. For this example, we 
#  will once again use http as our backend systems are a set of NGINX webservers.
#  
#  In addition to the mode parameter, this section also has a parameter called balance. The balance parameter is used to define the 
#  load-balancing algorithm that determines which backend node each request should be sent to. For this initial step, we can simply 
#  set this value to roundrobin, which is used to send traffic evenly as it comes in. This setting is pretty common and often the 
#  first load balancer that users start with.
#  
#  The final parameter in the backend service is server, which is used to define the backend system to balance to. In our example, 
#  there are two lines that each define a different server. These two servers are the NGINX webservers that we will load balancing 
#  traffic to in this example.
#  
#  The format of the server line is a bit different than the other parameters. This is because node-specific settings can be configured 
#  via the server parameter. In the example above, we are defining a label, IP:Port, and whether or not a health check should be used 
#  to monitor the backend node.    
#  
#  By specifying check after the web-server's address, we are defining that HAProxy should perform a health check to determine whether 
#  the backend system is responsive or not. If the backend system is not responsive, incoming traffic will not be routed to that 
#  backend system.
#  
#  With the changes above, we now have a basic HAProxy instance configured to load balance an HTTP service. In order for these 
#  configurations to take effect however, we will need to restart the HAProxy #  instance. We can do that with the systemctl 
#  command.
#
#  
# systemctl restart haproxy
