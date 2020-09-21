FROM golang:alpine AS builder

RUN apk update && \
    apk --no-cache add ca-certificates

RUN apk add git make

#creat directory and clone source
RUN cd ~ && \
    git clone https://github.com/skycoin/skywire.git && \
	cd skywire && \
    make build && make install

# visor image
FROM alpine:latest

# Install Certificates to establish SSL/TLS communication
RUN apk update && \
    apk --no-cache add ca-certificates

# Required Dependencis
RUN apk add su-exec openssl
	
# copy binaries files

COPY --from=builder /go/bin/hypervisor /usr/local/bin/

RUN mkdir -p /root/skywire

ENV CONFIG_DIR=/root/skywire/config

VOLUME $CONFIG_DIR

#set working directory
WORKDIR	/root
 
COPY config.sh ./

RUN chmod +x config.sh  

# start visor

CMD ["/bin/sh", "./config.sh"]