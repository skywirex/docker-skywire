FROM golang:alpine AS builder

RUN apk update && \
    apk --no-cache add ca-certificates

RUN apk add git make

#.Create directory and clone source
RUN cd ~ && \
    git clone https://github.com/skycoin/skywire.git && \
    cd skywire && \
    make build && make install

#.Visor image
FROM alpine:latest

#.Copy binaries files
COPY --from=builder /go/bin/. /usr/local/bin/
COPY --from=builder /root/skywire/apps /root/skywire/apps

ENV CONFIG_DIR=/opt/skywire

VOLUME $CONFIG_DIR

#.Set working directory
WORKDIR	/root/skywire
 
COPY *.sh ./

RUN chmod +x entrypoint.sh update.sh

RUN ./update.sh

#.Gennerate config file if it not exist
ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]