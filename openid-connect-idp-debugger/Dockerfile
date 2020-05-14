FROM openresty/openresty

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y upgrade

RUN opm install \
    bungle/lua-resty-session
    cdbattags/lua-resty-jwt \
    ledgetech/lua-resty-http \
    zmartzone/lua-resty-openidc \

EXPOSE 80 443
