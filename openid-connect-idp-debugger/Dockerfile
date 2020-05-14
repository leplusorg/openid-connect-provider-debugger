FROM openresty/openresty:alpine

RUN apk update \
 && apk add curl perl \
 && rm -rf /var/cache/apk/*

RUN opm install bungle/lua-resty-session \
 && opm install cdbattags/lua-resty-jwt \
 && opm install zmartzone/lua-resty-openidc

ADD nginx.conf.patch /usr/local/openresty/nginx/conf/nginx.conf.patch

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch

ADD default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443
