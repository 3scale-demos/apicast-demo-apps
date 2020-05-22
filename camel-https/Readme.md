# Endpoint-service

printf 'GET https://endpoint-service:443/ HTTP/1.1\r\nHost: endpoint-service\r\n\r\n' | ncat --ssl endpoint-service 443 --no-shutdown

