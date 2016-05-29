# Easy to run StatsD & Graphite docker container

# How to run 


## Docker machine IP
On linux docker is bind to `localhost`. Therefore to expose porst from docker container is sufficient. On mac, docker runs in virtual machine and therefore it is required to call services on special IP address (not `localhost`). Such IP address can be retrieved by calling command `docker-machine ip`
### For linux:
`export docker_machine_ip-ip="127.0.0.1"`
### For MAC
`export docker_machine_ip="$(docker-machine ip)"`

## Build & run
1. Clone repository
1. build `docker build -t docker-statsd-graphite .`
1. run `docker run -d -p 8000:8000 -p 80:80 -p 8125:8125/udp -p 8001:8001 --name docker-statsd-graphite docker-statsd-graphite`
1. generate some data `echo "foo:3|c" | nc -u -w0 $docker_machine_ip 8125`
1. view in browser: `http://$docker_machine_ip:8000/`

## Volumes
The data are not persistent between container restarts when running container without any volume mounted. To enable persistency mount volume `/root/graphite/storage`. Follows the example for testing purpose on MAC OSx:

```
docker run -d -p 8000:8000 -p 80:80 -p 8125:8125/udp -p 8001:8001 -v /Users/foo/storage:/root/graphite/storage --name stats stats
```

