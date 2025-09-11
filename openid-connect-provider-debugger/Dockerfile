# checkov:skip=CKV_DOCKER_3: [Missing USER]: inherited from parent image
# trivy:ignore:AVD-DS-0002: [Missing USER]: inherited from parent image
FROM openresty/openresty:1.27.1.2-4-alpine-fat@sha256:e93c5ab42fb6c7a882418c2bad0b39b566759f88c3fdd62f97264b621b6cba80

ARG LUA_RESTY_OPENIDC_VERSION="1.8.0-1"

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-ifsSL", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

RUN apk upgrade --no-cache \
    && apk add --no-cache \
    curl=8.12.1-r1 \
    patch=2.8-r0 \
    && apk cache --no-cache clean \
    && rm -rf /var/cache/apk/*

# We let lua-resty-session get pulled transitively to ensure compatibility
RUN if [ -z "${LUA_RESTY_OPENIDC_VERSION}" ]; then \
      luarocks install lua-resty-openidc ; \
    else \
      luarocks install lua-resty-openidc --pin "${LUA_RESTY_OPENIDC_VERSION}" ; \
    fi

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
    && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
