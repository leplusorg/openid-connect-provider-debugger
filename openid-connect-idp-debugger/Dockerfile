FROM openresty/openresty:alpine

RUN opm install bungle/lua-resty-session \
 && opm install cdbattags/lua-resty-jwt \
 && opm install ledgetech/lua-resty-http \
 && opm install zmartzone/lua-resty-openidc

EXPOSE 80 443
