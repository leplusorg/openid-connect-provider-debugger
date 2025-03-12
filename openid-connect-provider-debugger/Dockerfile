# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.27.1.1-alpine-fat@sha256:aa8ea52fa35a296558aed8b392fb39d575e39dd4a7717fa44f1fd6fc09c1185d

ARG LUA_RESTY_OPENIDC_VERSION="1.7.6"

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-i", "-s", "-S", "-f", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

# hadolint ignore=DL4006
RUN apk -U upgrade \
    && apk add \
    curl=8.12.1-r0 \
    patch=2.7.6-r10 \
    && if [[ $(apk -u list) ]] ; then \
      apk -u list ; \
      exit 1 ; \
    fi \
    && rm -rf /var/cache/apk/* \
    && /usr/local/openresty/luajit/bin/luarocks install lua-resty-openidc --pin "${LUA_RESTY_OPENIDC_VERSION}" \
    && patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
    && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
