FROM golang

ADD client.go /go/src/github.com/3scale/utils/client/
ADD server.go /go/src/github.com/3scale/utils/server/

RUN go get github.com/3scale/utils/client
RUN go get github.com/3scale/utils/server
RUN go install github.com/3scale/utils/client
RUN go install github.com/3scale/utils/server


# Run the outyet command by default when the container starts.
#ENTRYPOINT /go/bin/main

# Document that the service listens on port 8080.
#EXPOSE 8080
