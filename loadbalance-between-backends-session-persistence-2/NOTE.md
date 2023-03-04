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
#     systemctl restart haproxy
#
#
#### The structure of HAProxy configuration file is as follows:
#
#   global
#       # global settings here
#   
#   defaults
#       # defaults here
#   
#   frontend
#       # a frontend that accepts requests from clients
#   
#   backend
#       # servers that fulfill the requests
#   
## Global   
#
#  At the top of your HAProxy configuration file is the global section, identified by the word global on its own line. Settings 
#  under global define process-wide security and performance tunings that affect HAProxy at a low level.
#
#   global
#       maxconn 50000
#       log /dev/log local0
#       user haproxy
#       group haproxy
#       stats socket /run/haproxy/admin.sock user haproxy group haproxy mode 660 level admin
#       ssl-default-bind-ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:.....
#       ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets
#
## Defaults
#
#  As your configuration grows, using a defaults section will help reduce duplication. Its settings apply to all of the frontend and 
#  backend sections that come after it. You’re still free to override those settings within the sections that follow.
#
#  You also aren’t limited to having just one defaults. Subsequent defaults sections will override those that came before and reset 
#  all options to their default values.
#
#  So, you might decide to configure a defaults section that contains all of your TCP settings and then place your TCP-only frontend 
#  and backend sections after it. Then, place all of your HTTP settings in another defaults section and follow it with your HTTP 
#  frontend and backend sections.
#
#    defaults
#        timeout connect 10s
#        timeout client 30s
#        timeout server 30s
#        log global
#        mode http
#        option httplog
#        maxconn 3000
#
## Frontend
#
#  When you place HAProxy as a reverse proxy in front of your backend servers, a frontend section defines the IP addresses and ports 
#  that clients can connect to. You may add as many frontend sections as needed for exposing various websites to the Internet. Each 
#  frontend keyword is followed by a label, such as www.mysite.com, to differentiate it from others.
#
#    rontend www.mysite.com
#        bind 10.0.0.3:80
#        bind 10.0.0.3:443 ssl crt /etc/ssl/certs/mysite.pem
#        http-request redirect scheme https unless { ssl_fc }
#        use_backend api_servers if { path_beg /api/ }
#        default_backend web_servers
#
## Backend
#
#  A backend section defines a group of servers that will be load balanced and assigned to handle requests. You’ll add a label of your 
#  choice to each backend, such as web_servers. It’s generally, pretty straightforward and you won’t often need many settings here.
#
#    backend web_servers
#        balance roundrobin
#        cookie SERVERUSED insert indirect nocache
#        option httpchk HEAD /
#        default-server check maxconn 20
#        server server1 10.0.1.3:80 cookie server1
#        server server2 10.0.1.4:80 cookie server2
#
## What About Listen?
#
#  As you’ve seen, frontend and backend sections receive traffic and send it to a pool of servers. You can also use listen sections to 
#  do the same thing. They, essentially, combine the functionality of a frontend and backend into one. You may prefer the readability 
#  gained by having separate frontend and backend sections, especially when using HTTP mode with its many options, or you may favor a 
#  more concise configuration, making listen the preferred approach. In either case, you have the full power of HAProxy at your 
#  fingertips!
#
#    listen stats
#        bind *:8404
#        stats enable
#        stats uri /monitor
#        stats refresh 5s
#
#
#
#
#
#
#
#

