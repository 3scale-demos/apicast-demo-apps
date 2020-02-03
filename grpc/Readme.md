# GRPC guide for APICast. 

This explain how to setup GRPC calls on APICast server. 


## Pre-req:

All docker images are located in quay.io/3scale organization, but if you want to
build your own, here are the instructions:

GRPC client and server

```
export TARGET=quay.io/3scale/grpc-utils:golang
docker build -t ${TARGET} -f client.dockerfile .
docker push ${TARGET}
```

Certificates:

The certificates are embedded into the yaml files, but if you want to change the
values this is how are generated.

Root CA certificate:
```
openssl genrsa -out rootCA.key 2048
openssl req -batch -new -x509 -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.pem
```

Domain certificates for APICast

```
export DOMAIN=apicast-service
openssl req -subj "/CN=${DOMAIN}"  -newkey rsa:4096 -nodes \
    -sha256 \
    -days 3650 \
    -keyout ${DOMAIN}.key \
    -out ${DOMAIN}.csr
openssl x509 -req -in ${DOMAIN}.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out ${DOMAIN}.crt -days 3650 -sha256
```

Domain certificates for GRPC endpoint:

```
export DOMAIN=grpc-service
openssl req -subj "/CN=${DOMAIN}"  -newkey rsa:4096 -nodes \
    -sha256 \
    -days 3650 \
    -keyout ${DOMAIN}.key \
    -out ${DOMAIN}.csr
openssl x509 -req -in ${DOMAIN}.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out ${DOMAIN}.crt -days 3650 -sha256
```


## Traffic flow

## Installation

Openshift is needed to run this example:

```
oc apply -f apicast.yaml
oc apply -f client.yaml
oc apply -f endpoint.yaml
```


## Testing

Client directly call the grpc service. Plaintext connection.

```

oc exec -ti client --  /go/bin/client --address grpc-service:443 --name "Bob"
```

Client using APICast.

```
oc exec -ti client --  /go/bin/client --address apicast-service:8043 --name "Bob"
```


The current user_key is "test", but can be changed with the following command:

```
oc exec -ti client --  /go/bin/client --address apicast-service:8043 --name "Bob" --user_key="${MY_SECRET_KEY}"
```

Client help is the following, the connection is TLS but without validate the
certcertificates.

```
  -address string
        address to connect to (default "172.19.0.3:8043")
  -name string
        Name to say hello (default "world")
  -user_key string
        user_key to use it (default "test")
```
