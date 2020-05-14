FROM openresty/openresty

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y upgrade

RUN opm install bungle/lua-resty-session \
 && opm install cdbattags/lua-resty-jwt \
 && opm install ledgetech/lua-resty-http \
 && opm install zmartzone/lua-resty-openidc

EXPOSE 80 443
