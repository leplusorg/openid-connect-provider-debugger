FROM openresty/openresty:alpine

RUN apk update \
 && apk add perl \
 && rm -rf /var/cache/apk/*

RUN opm install bungle/lua-resty-session \
 && opm install cdbattags/lua-resty-jwt \
 && opm install ledgetech/lua-resty-http \
 && opm install zmartzone/lua-resty-openidc

EXPOSE 80 443
