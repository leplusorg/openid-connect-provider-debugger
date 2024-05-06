# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.25.3.1-alpine@sha256:654e5b4362c9e10880fffbb2a5c7cdf79e95e083d6a9c799815082ebe9f7e927

HEALTHCHECK CMD ["/usr/bin/curl", "-i", "-s", "-S", "-f", "http://localhost"]

# hadolint ignore=DL3018
RUN apk update \
 && LUA_VERSION=$(echo /usr/local/openresty/pod/lua-[0-9]*.[0-9]*.[0-9]* | sed -e 's!^/usr/local/openresty/pod/lua-!!; s/\.[0-9]*$//') \
 && echo "LUA_VERSION=${LUA_VERSION}" \
 && LUA_INCDIR=$(echo /usr/local/openresty/luajit/include/luajit-*) \
 && echo "LUA_INCDIR=${LUA_INCDIR}" \
 && apk --no-cache add curl "luarocks${LUA_VERSION}" patch \
 && rm -rf /var/cache/apk/* \
 && "luarocks-${LUA_VERSION}" config variables.LUA_INCDIR "${LUA_INCDIR}" \
 && "luarocks-${LUA_VERSION}" install lua-resty-openidc

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/nginx.conf.patch

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
 && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch \
 && chmod o+rwx /var/run/openresty

COPY default.conf /etc/nginx/conf.d/default.conf

COPY index.html /usr/local/openresty/nginx/html/index.html

EXPOSE 80 443
