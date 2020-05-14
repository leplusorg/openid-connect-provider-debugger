FROM openresty/openresty:alpine

RUN apk update \
 && apk add curl perl \
 && rm -rf /var/cache/apk/*

RUN opm install bungle/lua-resty-session \
 && opm install cdbattags/lua-resty-jwt \
 && opm install zmartzone/lua-resty-openidc

ADD default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443
