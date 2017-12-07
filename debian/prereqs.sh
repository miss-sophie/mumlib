#!/bin/bash
#
# debian/prereqs-ubuntu

set -e
set -x

dist="$1"
proxy="$2"

if [ -n "$proxy" ]; then
   export HTTP_PROXY=$proxy
   export HTTPS_PROXY=$proxy
   export http_proxy=$proxy
   export https_proxy=$proxy
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update

# 'Tuned' for Debian Stretch 2017-12
prereqs_debian () {
    apt-get install -y \
        cmake libboost-all-dev \
        debhelper \
        libssl1.0.2 libssl1.0-dev \
        liblog4cpp5v5 liblog4cpp5-dev \
        libopus-dev libprotobuf-dev \
        protobuf-compiler pkg-config
}

prereqs_ubuntu () {
    apt-get install -y \
        cmake debhelper \
        libboost-all-dev libboost-iostreams1.58.0 \
        libboost-log-dev libboost-log1.58.0 \
        libssl1.0.0 libssl-dev \
        liblog4cpp5v5 liblog4cpp5-dev \
        libopus-dev \
        libprotobuf9v5 libprotobuf-dev \
        protobuf-compiler pkg-config
}

case "$dist" in
    debian)
        prereqs_debian
        ;;
    ubuntu)
        prereqs_ubuntu
        ;;
    *)
        echo "ERROR: Argument required" >&2
        echo "       Usage: $0 <debian|ubuntu> [<apt-cache-proxy>]" >&2
        exit 1
        ;;
esac


