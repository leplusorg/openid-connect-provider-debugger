# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.25.3.1-alpine-fat@sha256:b60db904c43ac309ab0a54c997e19b84fb70cc456142febe7e2767a8b37383ee

HEALTHCHECK CMD ["/usr/bin/curl", "-i", "-s", "-S", "-f", "http://localhost"]

# hadolint ignore=DL3018,DL4006
RUN apk update \
 && apk --no-cache add curl patch \
 && rm -rf /var/cache/apk/* \
 && luarocks install lua-resty-openidc

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
 && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch \
 && chmod o+rwx /var/run/openresty

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
