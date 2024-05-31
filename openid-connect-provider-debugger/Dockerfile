# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.25.3.1-alpine-fat@sha256:17868b5ec232561bc64862160296c3f8480650bc4cbc19b88e056750bd78f527

HEALTHCHECK CMD ["/usr/bin/curl", "-i", "-s", "-S", "-f", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

# hadolint ignore=DL3018,DL4006
RUN apk update \
 && apk --no-cache add curl patch \
 && rm -rf /var/cache/apk/* \
 && /usr/local/openresty/luajit/bin/luarocks install lua-resty-openidc \
 && patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
 && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
