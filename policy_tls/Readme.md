Examples:



```
--> kubectl exec -ti client -- curl "https://apicast-service:8043/headers?user_key=foo" -v -k
*   Trying 172.30.238.254:8043...
* Connected to apicast-service (172.30.238.254) port 8043 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: none
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Request CERT (13):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Certificate (11):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=apicast-service.eloy-performance.svc
*  start date: Jun  3 09:41:44 2021 GMT
*  expire date: Jun  3 09:41:45 2023 GMT
*  issuer: CN=openshift-service-serving-signer@1599048062
*  SSL certificate verify result: self signed certificate in certificate chain (19), continuing anyway.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x55aade9bfac0)
> GET /headers?user_key=foo HTTP/2
> Host: apicast-service:8043
> user-agent: curl/7.77.0-DEV
> accept: */*
>
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
< HTTP/2 200
< server: openresty
< date: Thu, 03 Jun 2021 10:07:27 GMT
< content-type: application/json
< content-length: 177
< access-control-allow-origin: *
< access-control-allow-credentials: true
<
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.77.0-DEV",
    "X-Amzn-Trace-Id": "Root=1-60b8a9df-790c7f150107fee850b46f19"
  }
}
* Connection #0 to host apicast-service left intact
```

Using router
```
--> curl "https://example-eloy-performance.apps.dev-eng-ocp4-5.dev.3sca.net/headers?user_key=foo" -k -v
*   Trying 54.164.19.69:443...
* Connected to example-eloy-performance.apps.dev-eng-ocp4-5.dev.3sca.net (54.164.19.69) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Request CERT (13):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Certificate (11):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=apicast-service.eloy-performance.svc
*  start date: Jun  3 09:41:44 2021 GMT
*  expire date: Jun  3 09:41:45 2023 GMT
*  issuer: CN=openshift-service-serving-signer@1599048062
*  SSL certificate verify result: self signed certificate in certificate chain (19), continuing anyway.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x55ed448e9ea0)
> GET /headers?user_key=foo HTTP/2
> Host: example-eloy-performance.apps.dev-eng-ocp4-5.dev.3sca.net
> user-agent: curl/7.71.1
> accept: */*
>
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
< HTTP/2 200
< server: openresty
< date: Thu, 03 Jun 2021 10:07:33 GMT
< content-type: application/json
< content-length: 173
< access-control-allow-origin: *
< access-control-allow-credentials: true
<
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.71.1",
    "X-Amzn-Trace-Id": "Root=1-60b8a9e6-2b699aa31a2c87a3728a4169"
  }
}
* Connection #0 to host example-eloy-performance.apps.dev-eng-ocp4-5.dev.3sca.net left intact
-->
```
