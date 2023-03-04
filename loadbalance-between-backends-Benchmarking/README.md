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
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#    This is HTTP Echo server bank-server-node1 
#    This is HTTP Echo server bank-server-node2 
#       ...
#        
#    
#
### Tipsa
#
## Generic hash load balancing algorithm
#
#  You can use the new load balancing algorithm, hash, in place of the existing, more specific hash algorithms source, uri, 
#  hdr, url_param, and rdp-cookie. 
#
#  The new algorithm is generic, thus allowing you to pass in a sample fetch of the data used to calculate the hash.
#
#  In the example below, the pathq fetch returns the URL path and query string for the data to hash:
#
#    backend cache_servers
#      balance hash pathq
#      hash-type consistent
#    
#      server cache1 192.168.56.30:80 check maxconn 30
#      server cache2 192.168.56.31:80 check maxconn 30
#
## Listing configuration keywords
#
#  Have you ever wanted to know whether a configuration keyword is supported in the version of HAProxy 
#  you’re running?
#
#  You can now ask HAProxy to return to you a list. Keywords are sorted into classes, so first get the 
#  list of classes by passing the -dKhelp argument to HAProxy, along with the quiet (-q), validation 
#  check (-c) and configuration file (-f) arguments:
#
#      haproxy -dKhelp -q -c -f /dev/null
#
#        # List of supported keyword classes:
#        all: list all keywords
#        acl: ACL keywords
#        cfg: configuration keywords
#        cli: CLI keywords
#        cnv: sample converter keywords
#        flt: filter names
#        smp: sample fetch functions
#        svc: service names
#
#  Then get a list of keywords, for example:
#
#      haproxy -dKacl -q -c -f /dev/null
#
#        # List of registered ACL keywords:
#        base = base -m str
#        base_beg = base -m beg
#        base_dir = base -m dir
#        base_dom = base -m dom
#        base_end = base -m end
#        base_len = base -m len
#        base_reg = base -m reg
#        base_sub = base -m sub
#        [...]
#
## Variables
#
#  Variables let you store information about a request or response and reference that information within logical 
#  statements elsewhere in your configuration file. 
#
#  HAProxy 2.6 makes it simple to check whether a variable already exists or already has a value before trying to 
#  set it again. 
#
#  All tcp- and http- set-var actions, such as http-request set-var and tcp-request content set-var, now support 
#  the new parameter.
#
#  For example, if you wanted to set a variable named token to the value of an HTTP header named X-Token, but fall back 
#  to setting it to the value of a URL parameter named token if the header doesn’t exist, you could use the condition 
#  isnotset to check whether the variable has a value from the first case before trying to set it again:
#
#     frontend mywebsite
#       bind :80
#     
#       # try using the value from the X-Token header
#       http-request set-var(txn.token) req.hdr(X-Token)
#     
#       # fall back to using the value from the URL parameter 'token'
#       http-request set-var(txn.token,ifnotset) url_param(token)
#     
#       # log the variable
#       http-request capture var(tnx.token) len 10
#       default_backend webservers
#
#  You can use the following, built-in conditions:
#
#  Condition	Sets the new value when…
#
#  ifexists	the variable was previously created with a set-var call.
#
#  ifnotexists	the variable has not been created yet with a set-var call.
#
#  ifempty	the current value is empty. This applies for nonscalar types (strings, binary data).
#
#  ifnotempty	the current value is not empty. This applies for nonscalar types (strings, binary data).
#
#  ifset	the variable has been set and unset-var has not been called. A variable that does not exist is also considered unset.
#
#  ifnotset	the variable has not been set or unset-var was called.
#
#  ifgt	        the variable’s existing value is greater than the new value.
#
#  iflt	        the variable’s existing value is less than the new value.
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#


