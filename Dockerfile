FROM alpine:latest

ENV LANG en_US.UTF-8

ENV _3PROXY_VERSION 0.9.4
ENV _3PROXY_DOWNLOAD_URL https://github.com/3proxy/3proxy/archive/refs/tags/${_3PROXY_VERSION}.tar.gz
ENV _3PROXY_DOWNLOAD_SHA1 1a193838079c0b1a07f063ef3a738493a8240d68

LABEL version="${_3PROXY_VERSION}"

RUN \
    set -ex && \
    apk add alpine-sdk linux-headers && \
    export DIR=$(mktemp -d) && \
    cd $DIR && \
    wget -O 3proxy.tar.gz ${_3PROXY_DOWNLOAD_URL} && \
    echo "${_3PROXY_DOWNLOAD_SHA1} *3proxy.tar.gz" | sha1sum -c - && \
    mkdir 3proxy && \
    tar -xzf 3proxy.tar.gz -C 3proxy --strip-components=1 && \
    cd 3proxy && \
    make -f Makefile.Linux || true && \
    mv bin/3proxy /usr/local/bin/ && \
    cd && \
    rm -rf $DIR && \
    apk del alpine-sdk linux-headers

EXPOSE 3128
EXPOSE 8080
CMD ["/usr/local/bin/3proxy", "/etc/3proxy.conf"]
