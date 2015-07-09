#!/bin/bash

if [ "${VIRTUAL_HOST}" = "**None**" ]; then
    unset VIRTUAL_HOST
fi

if [ "${SSL_CERT}" = "**None**" ]; then
    unset SSL_CERT
fi

if [ "${BACKEND_PORTS}" = "**None**" ]; then
    unset BACKEND_PORTS
fi

if [ -n "$SSL_CERT" ]; then
    echo "SSL certificate provided!"
    echo -e "${SSL_CERT}" > /servercert.pem
    export SSL="ssl crt /servercert.pem"
else
    echo "No SSL certificate provided"
fi

mkdir -p /etc/haproxy/errorfiles
wget http://s3-eu-west-1.amazonaws.com/hoshinplan/error_503.html -O /etc/haproxy/errors/503.http
sed -i -e '1i\
HTTP/1.0 503 Service Unavailable\
Cache-Control: no-cache\
Connection: close\
Content-Type: text/html\

' /etc/haproxy/errors/503.http

exec python /app/haproxy.py 
