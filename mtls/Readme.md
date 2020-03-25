# MTLS policy demo


## Install

```
./install.sh
```

## Test

```
oc exec client -- curl "http://apicast-service:8080?user_key=foo" -v
```
