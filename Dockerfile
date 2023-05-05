# Golang runtime as a parent image
FROM golang:1.17-alpine3.14 AS builder

# Define build env
ENV CGO_ENABLED=0 \
    GOOS=linux

# Set the working dir to go/src/app
WORKDIR /go/src/app

# Download all dependencies
RUN go mod download

# Copy only necessary files for go mod to download dependencies
COPY go.mod go.sum ./

# Copy the entire directory containing the main.go file
COPY cmd/ ./cmd/

# Build go app named main
RUN go build -o main ./cmd/

# Minimal Alpine image as a base image
FROM alpine:3.14 AS production

# Add certification (CA)
RUN apk add --no-cache ca-certificates

# Set the working directory to  /app
WORKDIR /app

# Copy the binary from the prev build stage
COPY --from=builder /go/src/app/main .

# Expose port 8080 for the container
EXPOSE 8080

# Starts the binary when the container starts
CMD ["./main"]