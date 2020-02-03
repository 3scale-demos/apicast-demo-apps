/*
 *
 * Copyright 2015 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

// Package main implements a client for Greeter service.
package main

import (
	"context"
	"crypto/tls"
	"flag"
	"fmt"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	pb "google.golang.org/grpc/examples/helloworld/helloworld"
	"google.golang.org/grpc/metadata"
)

const (
	defaultAddress = "172.19.0.3:8043"
	defaultName    = "world"
)

func main() {

	address := flag.String("address", defaultAddress, "address to connect to")
	name := flag.String("name", defaultName, "Name to say hello")
	user_key := flag.String("user_key", "test", "user_key to use it")
	fmt.Println("\t- Address:", *address)
	fmt.Println("\t- Name:", *name)
	fmt.Println("\t- User_key:", *user_key)
	flag.Parse()

	config := &tls.Config{
		InsecureSkipVerify: true,
	}
	conn, err := grpc.Dial(*address, grpc.WithTransportCredentials(credentials.NewTLS(config)))
	// Set up a connection to the server.
	// conn, err := grpc.Dial(address, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewGreeterClient(conn)

	md := metadata.Pairs("user_key", *user_key)
	ctx := metadata.NewOutgoingContext(context.Background(), md)
	ctx, cancel := context.WithTimeout(ctx, time.Second)
	defer cancel()
	r, err := c.SayHello(ctx, &pb.HelloRequest{Name: *name})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.GetMessage())
}
