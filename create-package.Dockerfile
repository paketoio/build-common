FROM golang:latest AS build

RUN go get -u github.com/GoogleCloudPlatform/docker-credential-gcr \
    && cp ${GOPATH}/bin/docker-credential-gcr /tmp/docker-credential-gcr

FROM golang:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    git \
    jq \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /tmp/docker-credential-gcr /usr/local/bin/

RUN docker-credential-gcr configure-docker
