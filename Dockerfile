FROM node:alpine
WORKDIR /site
RUN apk update && \
#    apk add --update --repository http://dl-3.alpinelinux.org/alpine/edge/testing vips-tools vips-dev fftw-dev gcc g++ make libc6-compat && \
    apk add git && \
    apk add python && \
    apk add openssl && \
    rm -rf /var/cache/apk/* && \
    npm install -g gatsby-cli

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
