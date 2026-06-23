#!/bin/sh
envsubst '${BACKEND_VENTAS_URL} ${BACKEND_DESPACHOS_URL}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'
