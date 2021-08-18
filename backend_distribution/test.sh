#!/bin/bash

function print_status() {
  for row in $(kubectl get pods -l app=backend -o json | jq -r '.items[] | .metadata.name + ":" + .status.podIP'); do 
    POD=$(echo $row | cut -f1 -d:)
    IP=$(echo $row | cut -f2 -d:)
    RES=$(kubectl exec -ti client -- curl http://${IP}:9421/metrics -s| grep "^apicast_status")
    echo "POD --> $POD"
    echo "${RES}"
  done
}

echo "BEFORE START"
print_status

echo "HEY client for 10m"
kubectl exec -ti heyclient -- /hey -z 10m http://apicast-service:8080/?user_key=foo

echo "-------------------------------------------------"

echo "AFTER TEST"
print_status
