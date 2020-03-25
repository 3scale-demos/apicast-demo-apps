echo "***************** Init process  *************************"

function echo {
  COLOR="\e[93m";
  ENDCOLOR="\e[0m";
  printf "$COLOR%b$ENDCOLOR\n" "$1";
}

echo ">> Clean old data"
rm -v rootCA.*
rm -v client.*

oc delete -f 00_client.yaml
oc delete -f 00_endpoint.yaml
oc delete -f 00_apicast.yaml

echo ">> SSL create CA cert"
openssl genrsa -out rootCA.key 2048
openssl req -batch -new -x509 -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem


echo ">> SSL create client cert"
openssl genrsa -out client.key 4096
openssl req -new -subj '/CN=test' -key client.key -out client.req
openssl x509 -req -in client.req \
  -CA rootCA.pem -CAkey rootCA.key \
  -CAcreateserial -out client.crt \
  -days 500 -sha256

function read_certificate {
  printf "%b\n" $(cat $1 | base64| tr -d '\n')
}

echo ">> OC create secret"

cat <<EOF | oc apply -f -
kind: Secret
apiVersion: v1
type: Opaque
metadata:
  name: "endpoint-client-certs"
data:
  client.cert: "$(read_certificate client.crt)"
  client.key: "$(read_certificate client.key)"
  rootCA.key: "$(read_certificate rootCA.key)"
  rootCA.pem: "$(read_certificate rootCA.pem)"
EOF


echo ">> Apply client"
oc apply -f 00_client.yaml

echo ">> Apply endpoint"
oc apply -f 00_endpoint.yaml

echo ">> Apply endpoint"
oc apply -f 00_apicast.yaml

echo ">> Wait until pods are ready"
while [[ $(oc get pods -l need=yes -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' |  tr " " "\n" | sort -u) != "True" ]]; do
  echo ">> Waiting for pods to be ready";
  oc get pods
  sleep 1;
done


oc exec client -- curl https://endpoint-service \
  --cert /client_secrets/client.cert \
  --key /client_secrets/client.key \
  -k
