# Build Geth in a stock Go builder container
FROM golang:1.15-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

RUN git clone https://github.com/Ether1Project/Ether1.git /go-etho
RUN cd /go-etho && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache openrc bash sudo bind-tools libcap supervisor 
RUN apk add --no-cache ca-certificates
COPY --from=builder /go-etho/build/bin/geth /usr/sbin/

ARG USER=ether1node
ARG HOME=/home/$USER
RUN adduser -D $USER && mkdir -p /etc/sudoers.d \
        && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
        && chmod 0440 /etc/sudoers.d/$USER
USER $USER
WORKDIR $HOME

RUN sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/geth
RUN wget --no-cache https://raw.githubusercontent.com/Ether1Project/etho-flux/main/launch.sh
RUN sudo chown ether1node.ether1node launch.sh

EXPOSE  4001 5001 30305 30305/udp
