# Camel example


## Traffic flow. 

```
 ,-.                                                                                                                             
 `-'                                                                                                                             
 /|\           ,--------------------.          ,------------------.          ,--------------------.          ,------------------.
  |            |Apicast             |          |3scale Backend    |          |Camel               |          |API-endpoint      |
 / \           |(172.30.136.10:8080)|          |(172.30.136.11:80)|          |(172.30.136.15:9090)|          |(172.30.136.12:80)|
User           `---------+----------'          `--------+---------'          `---------+----------'          `------------------'
 |     GET /resource     |                              |                              |                              |          
 | ---------------------->                              |                              |                              |          
 |                       |                              |                              |                              |          
 |                       |         IsValidUser()        |                              |                              |          
 |                       | ----------------------------->                              |                              |          
 |                       |                              |                              |                              |          
 |                       |              yes             |                              |                              |          
 |                       | <-----------------------------                              |                              |          
 |                       |                              |                              |                              |          
 |                       |                        Get /resource                        |                              |          
 |                       | ------------------------------------------------------------>                              |          
 |                       |                              |                              |                              |          
 |                       |                              |                              |        Get /resource/        |          
 |                       |                              |                              |  - - - - - - - - - - - - - - >          
 |                       |                              |                              |                              |          
 |                       |                              |                              |           response           |          
 |                       |                              |                              | <- - - - - - - - - - - - - - -          
 |                       |                              |                              |                              |          
 |                       |                           response                          |                              |          
 |                       | <------------------------------------------------------------                              |          
 |                       |                              |                              |                              |          
 |                       |                              |                              |                              |          
 | <----------------------                              |                              |                              |          
User           ,---------+----------.          ,--------+---------.          ,---------+----------.          ,------------------.
 ,-.           |Apicast             |          |3scale Backend    |          |Camel               |          |API-endpoint      |
 `-'           |(172.30.136.10:8080)|          |(172.30.136.11:80)|          |(172.30.136.15:9090)|          |(172.30.136.12:80)|
 /|\           `--------------------'          `------------------'          `--------------------'          `------------------'
  |                                                                                                                              
 / \                                                                                                                             
```

Plantuml: 

```
@startuml

scale 2.0

actor User
participant "Apicast\n(172.30.136.10:8080)" as Apicast
participant "3scale Backend\n(172.30.136.11:80)" as AUTHBackend
participant "Camel\n(172.30.136.15:9090)" as HTTPPROXY
control "API-endpoint\n(172.30.136.12:80)" as APIBackend

User->Apicast : GET /resource
Apicast-[#red]>AUTHBackend: IsValidUser()
AUTHBackend-[#red]>Apicast: yes
Apicast-[#blue]>HTTPPROXY: Get /resource
HTTPPROXY-[#blue]->APIBackend: Get /resource/
APIBackend-[#blue]->HTTPPROXY: response
HTTPPROXY-[#blue]>Apicast: response
Apicast -> User
@enduml
```

## Installation

Openshift: 

```
oc new-project camelproxy
```

```
oc apply -f apicast.yaml
oc apply -f camel.yaml
oc apply -f client.yaml
oc apply -f endpoint.yaml
```

## Testing

Client call directly to the API endpoint:

```
oc exec client -- curl -s "http://172.30.136.12:80"
```

Client call using HTTP proxy with Camel:

```
oc exec client -- bash -c 'http_proxy="172.30.136.15:9090" curl -s "http://172.30.136.12:80"'
```

Client call to the Apicast service using Camel Proxy: 
```
oc exec client -- curl -H "Host: one" -s "http://172.30.136.10:8080?user_key=123"
```

### Cleanup

```
oc delete project camelproxy
```
