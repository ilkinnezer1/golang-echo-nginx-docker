# Golang (Echo Labstack) Containerization with Nginx for Production

### Golang Runtime as a Parent Image
This Dockerfile is designed to create a container image that runs a Golang application. 
It uses the `golang:1.17-alpine3.14` image as the parent image for the `builder` stage, and `alpine:3.14` as the parent image for the production stage. 

#### Brief explanation of each step in the Dockerfile:

### Builder Stage
The builder stage is responsible for compiling the Golang application and generating the binary file that will be used in the production stage.

`FROM golang:1.17-alpine3.14 AS builder` - sets the `golang:1.17-alpine3.14` image as the parent image for the builder stage. </br></br>
`ENV CGO_ENABLED=0 GOOS=linux` - env variables are set to disable CGO and specify the target operating system as Linux. </br></br>
`WORKDIR /go/src/app` - sets the working directory for the builder stage to /go/src/app. </br></br>
`RUN go mod download` - downloads all the necessary dependencies required to build the Golang application. </br></br>
`COPY go.mod go.sum ./` - copies the `go.mod` and `go.sum` files to the current working directory of the container. </br></br>
`RUN go build -o main ./cmd/` - builds the Golang application and generates a binary file named main in the cmd directory.</br></br>

### Production Stage
The production stage is responsible for creating the final container image that will run the Golang application.

`FROM alpine:3.14 AS production` - sets the `alpine:3.14` image as the parent image for the production stage. </br></br>
`RUN apk add --no-cache ca-certificates` - installs the ca-certificates package, which is required to establish SSL connections.</br></br>
`WORKDIR /app` - sets the working directory for the production stage to `/app.` </br></br>
`COPY --from=builder /go/src/app/main .` - copies the binary file named main from the builder stage to the current working directory of the container.</br></br>
`EXPOSE 8080` - exposes port 8080 for the container. </br></br>
`CMD ["./main"]` - runs the binary file named main when the container starts. </br></br>