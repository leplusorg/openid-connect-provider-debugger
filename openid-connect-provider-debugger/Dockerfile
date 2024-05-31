# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.25.3.1-alpine@sha256:bb29ac9303db64bf2736766fa2b2b9904b50514f9e3733ce81e1b8d0e65d2a69

HEALTHCHECK CMD ["/usr/bin/curl", "-i", "-s", "-S", "-f", "http://localhost"]

# hadolint ignore=DL3018,DL4006
RUN apk update \
 && LUA_VERSION=$(echo /usr/local/openresty/pod/lua-[0-9]*.[0-9]*.[0-9]* | sed -e 's!^/usr/local/openresty/pod/lua-!!; s/\.[0-9]*$//') \
 && echo "LUA_VERSION=${LUA_VERSION}" \
 && LUA_INCDIR=$(echo /usr/local/openresty/luajit/include/luajit-*) \
 && echo "LUA_INCDIR=${LUA_INCDIR}" \
 && apk --no-cache add curl "luarocks${LUA_VERSION}" patch \
 && rm -rf /var/cache/apk/* \
 && "luarocks-${LUA_VERSION}" config variables.LUA_INCDIR "${LUA_INCDIR}" \
 && "luarocks-${LUA_VERSION}" install lua-resty-openidc

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
 && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch \
 && chmod o+rwx /var/run/openresty

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
