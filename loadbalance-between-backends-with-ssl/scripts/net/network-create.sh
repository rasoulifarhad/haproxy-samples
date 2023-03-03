net=server-network
echo "creating network $net"
docker network create --driver=bridge "$net"

