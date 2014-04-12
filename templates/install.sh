#!/bin/sh

curl -sL https://s3.amazonaws.com/bitly-downloads/nsq/nsq-<%= @version %>.linux-amd64.go1.2.tar.gz | tar -xzf -
cd nsq-<%= @version %>*
cp bin/* /usr/local/bin
