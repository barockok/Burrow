FROM golang:alpine
ARG BUILD_VERSION=1
RUN apk add --no-cache make curl bash git ca-certificates wget \
 && update-ca-certificates \
 && curl -sSO https://raw.githubusercontent.com/pote/gpm/v1.4.0/bin/gpm \
 && chmod +x gpm \
 && mv gpm /usr/local/bin

ADD . $GOPATH/src/github.com/linkedin/Burrow
RUN cd $GOPATH/src/github.com/linkedin/Burrow \
 && go get github.com/klauspost/crc32 \
 && gpm install

WORKDIR $GOPATH/src/github.com/linkedin/Burrow