# syntax=docker/dockerfile:1

FROM golang:1.24 AS build
# Set destination for COPY
WORKDIR /app

# Download Go modules
COPY container/go.mod ./
RUN go mod download

# Copy container src
COPY container/*.go ./
# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /server

FROM debian:latest

RUN apt-get update \
    && apt-get install -y python3 nodejs npm \
    && npm install -g @google/clasp

COPY --from=build /server /server

EXPOSE 8080
# Run
CMD ["/server"]
