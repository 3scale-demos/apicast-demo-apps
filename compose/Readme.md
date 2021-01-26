# Docker compose example

# Install

```
docker-compose up
```

# Test:

```
export CIP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' compose_proxy_1)
curl -H "Host: apicast-service" "http://${CIP}:8080/?user_key=123" -v
```
