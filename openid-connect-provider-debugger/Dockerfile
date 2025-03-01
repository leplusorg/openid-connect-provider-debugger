# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.27.1.1-alpine-fat@sha256:aa8ea52fa35a296558aed8b392fb39d575e39dd4a7717fa44f1fd6fc09c1185d

ARG LUA_RESTY_OPENIDC_VERSION="1.7.6"

HEALTHCHECK CMD ["/usr/bin/curl", "-i", "-s", "-S", "-f", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

# hadolint ignore=DL3018,DL4006
RUN apk update \
 && apk --no-cache add curl patch \
 && rm -rf /var/cache/apk/* \
 && /usr/local/openresty/luajit/bin/luarocks install lua-resty-openidc --pin "${LUA_RESTY_OPENIDC_VERSION}" \
 && patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
 && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
