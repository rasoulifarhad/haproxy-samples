### Application layer persistence
#
#  Since a web application server has to identify each users individually, to avoid serving content from a user to an 
#  other one, we may use this information, or at least try to reproduce the same behavior in the load-balancer to 
#  maintain persistence between a user and a server.
#
#  The information we’ll use is the Session Cookie, either set by the load-balancer itself or using one set up by 
#  the application server.
#
## IP source affinity to server 
#
#  An easy way to maintain affinity between a user and a server is to use user’s IP address: this is called 
#  Source IP affinity.
#
## The difference between persistence and affinity
#
#  - Affinity: this is when we use an information from a layer below the application layer to maintain a 
#    client request to a single server
#
#  - Persistence: this is when we use Application layer information to stick a client to a single server
#
#  - sticky session: a sticky session is a session maintained by persistence
#
#  The main advantage of the persistence over affinity is that it’s much more accurate, but sometimes, 
#  Persistence is not doable, so we must rely on affinity.
#
#  Using persistence, we mean that we’re 100% sure that a user will get redirected to a single server.
#
#  Using affinity, we mean that the user may be redirected to the same server…
#
## The interaction with load-balancing
#
#  persistence means that the server can be chosen based on application layer information.
#
#  This means that persistence is an other way to choose a server from a farm, as load-balancing algorithm 
#  does.
#
#  Actually, session persistence has precedence over load-balancing algorithm.
#
#  Let’s show this on a diagram:
#
#
#        client request
#              |
#              V
#      HAProxy Frontend
#              |
#              V
#       backend choise	
#              |
#              V
#      HAProxy Backend
#              |
#              V
#   Does the request contain
#   persistence information  ---------------
#              |                            |	
#              | NO                         |
#              V                            |
#      Server choice by                     | YES
#   load-balancing algorithm                |
#              |                            |
#              V                            | 
#     Forwarding request  <------------------                   
#        to the server
# 
#  Which means that when doing session persistence in a load balancer, the following happens:
#
#    - the first user’s request comes in without session persistence information
#    - the request bypass the session persistence server choice since it has no session persistence information
#    - the request pass through the load-balancing algorithm, where a server is chosen and affected to the client
#    - the server answers back, setting its own session information
#    - depending on its configuration, the load-balancer can either use this session information or setup its own 
#      before sending the response back to the client
#    - the client sends a second request, now with session information he learnt during the first request
#    - the load-balancer choose the server based on the client side information
#    - the request DOES NOT PASS THROUGH the load-balancing algorithm
#    - the server answers the request
#
#  and so on…  "Persistence is a exception to load-balancing“
#
## Affinity configuration in HAProxy
#
#    frontend ft_web
#      bind 0.0.0.0:80
#      default_backend bk_web
#
#    backend bk_web
#      balance source
#      hash-type consistent # optional
#      server s1 192.168.10.11:80 check
#      server s2 192.168.10.21:80 check
#
## Web application persistence
#
#  In order to provide persistence at application layer, we usually use Cookies.
#
#  there are two ways to provide persistence using cookies:
#
#  - Let the load-balancer set up a cookie for the session.
#
#  - Using application cookies, such as ASP.NET_SessionId, JSESSIONID, PHPSESSIONID, or any other 
#    chosen name
#
## Session cookie setup by the Load-Balancer
#
#  The configuration below shows how to configure HAProxy load balancer to inject a cookie in the 
#  client browser:
#
#    frontend ft_web
#      bind 0.0.0.0:80
#      default_backend bk_web
#
#    backend bk_web
#      balance roundrobin
#      cookie SERVERID insert indirect nocache
#      server s1 192.168.10.11:80 check cookie s1
#      server s2 192.168.10.21:80 check cookie s2
#
#  Two things to notice:
# 
#  	1. the line “cookie SERVERID insert indirect nocache”:
#
#          This line tells HAProxy to setup a cookie called SERVERID only if the user did not come with such cookie. It 
#          is going to append a “Cache-Control: nocache” as well, since this type of traffic is supposed to be personnal 
#          and we don’t want any shared cache on the internet to cache it
#
#       2. the statement “cookie XXX” on the server line definition:
#
#          It provides the value of the cookie inserted by HAProxy. When the client comes back, then HAProxy knows directly 
#          which server to choose for this client.
#
#  So what happens?
#
#  1. At the first response, HAProxy will send the client the following header, if the server chosen by the load-balancing 
#     algorithm is s1:
#
#        Set-Cookie: SERVERID=s1
#
#  2. For the second request, the client will send a request containing the header below:
#
#        Cookie: SERVERID=s1 
#
## Using application session cookie for persistence
#
#  The configuration below shows how to configure HAProxy to use the cookie setup by the application 
#  server to maintain affinity between a server and a client:
#
#    frontend ft_web
#      bind 0.0.0.0:80
#      default_backend bk_web
#
#    backend bk_web
#      balance roundrobin
#      cookie JSESSIONID prefix nocache
#      server s1 192.168.10.11:80 check cookie s1
#      server s2 192.168.10.21:80 check cookie s2
#
#  Just replace JSESSIONID by your application cookie. It can be anything, like the default ones from PHP and 
#  IIS: PHPSESSID and ASP.NET_SessionId.
#
#  So what happens?
#
#  1. At the first response, the server will send the client the following header
#
#      [sourcecode language=”text”]Set-Cookie: JSESSIONID=i12KJF23JKJ1EKJ21213KJ[/sourcecode]
#
#  2. when passing through HAProxy, the cookie is modified like this:
#
#      Set-Cookie: JSESSIONID=s1~i12KJF23JKJ1EKJ21213KJ
#
#  3. For the second request, the client will send a request containing the header below:
#
#      Cookie: JSESSIONID=s1~i12KJF23JKJ1EKJ21213KJ
#
#  4. HAProxy will clean it up on the fly to set it up back like the origin:
#
#      Cookie: JSESSIONID=i12KJF23JKJ1EKJ21213KJ
#
## What happens when a server goes down
#
#  When doing persistence, if a server goes down, then HAProxy will redispatch the user to an other server.
# 
#  Since the user will get connected on a new server, then this one may not be aware of the session, so be 
#  redirected to the login page.
#
#  But this is not a load-balancer problem, this is related to the application server farm.
#
### Run && Test
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
#  Go to test folder and run test-ha-send-server-s1-with-cookei.sh function
#
#      cd scripts/test
#      ./test-ha-send-server-s1-with-cookei.sh
#
#  You must see :
#
#    Starting.......
#    
#    This test continuously sends requests to the server
#    with an interval of one second between them .
#    
#    Requests are sent to the haproxy http frontend address 
#    on port 80 , with cookie --cookie "SERVERID=s1" 
#    
#          http://localhost:80
#    
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node1 
#       ...
#
## 3. Test 
#
#  Go to test folder and run test-ha-send-server-s2-with-cookei.sh function
#
#      cd scripts/test
#      ./test-ha-send-server-s2-with-cookei.sh
#
#  You must see :
#
#    Starting.......
#    
#    This test continuously sends requests to the server
#    with an interval of one second between them .
#    
#    Requests are sent to the haproxy http frontend address 
#    on port 80 , with cookie --cookie "SERVERID=s2" 
#    
#          http://localhost:80
#    
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node2 
#       ...
#        
#

