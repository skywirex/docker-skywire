FROM golang:alpine AS builder

RUN apk update && \
    apk --no-cache add ca-certificates

RUN apk add git make

#creat directory and clone source
RUN cd ~ && \
    git clone https://github.com/SkycoinProject/skywire-mainnet.git && \
	cd skywire-mainnet && \
    make build && make install

# visor image
FROM alpine:latest

# Install Certificates to establish SSL/TLS communication
RUN apk update && apk upgrade && \
    apk --no-cache add ca-certificates

# Required Dependencis
RUN apk add su-exec openssl iproute2 && \
	apk add --update bash curl	
	
# copy binaries files

COPY --from=builder /go/bin/. /usr/local/bin/
COPY --from=builder /root/skywire-mainnet/apps /root/skywire-mainnet/apps

ENV CONFIG_DIR=/root/skywire/config

VOLUME $CONFIG_DIR

#set working directory
WORKDIR	/root
 
COPY skywire-config.sh ./

#COPY update.sh ./
	
RUN chmod +x skywire-config.sh

# start visor

CMD ["/bin/sh", "./skywire-config.sh"]