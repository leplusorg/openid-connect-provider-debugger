FROM openresty/openresty:alpine

RUN apk update \
 && apk add curl patch perl \
 && rm -rf /var/cache/apk/* \
 && opm install bungle/lua-resty-session \
 && opm install cdbattags/lua-resty-jwt \
 && opm install zmartzone/lua-resty-openidc

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/nginx.conf.patch

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch

COPY default.conf /etc/nginx/conf.d/default.conf

COPY index.html /usr/local/openresty/nginx/html/index.html

EXPOSE 80 443
