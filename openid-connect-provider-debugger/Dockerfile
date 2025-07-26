# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.27.1.2-2-alpine-fat@sha256:7924c127ab0d612680b43f6ae94c8f6f8b3b009d11f8f9b912f28df129a71add

ARG LUA_RESTY_OPENIDC_VERSION="1.8.0-1"

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-ifsSL", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

# hadolint ignore=DL3019
RUN apk -U upgrade \
    && apk add \
    curl=8.12.1-r1 \
    patch=2.7.6-r10 \
    && if apk -u list | grep -q -e . ; then \
      apk -u list ; \
      exit 1 ; \
    fi \
    && apk cache clean \
    && rm -rf /var/cache/apk/*

# We let lua-resty-session get pulled transitively to ensure compatibility
RUN if [ -z "${LUA_RESTY_OPENIDC_VERSION}" ]; then \
      luarocks install lua-resty-openidc ; \
    else \
      luarocks install lua-resty-openidc --pin "${LUA_RESTY_OPENIDC_VERSION}" ; \
    fi \
    && if luarocks list --outdated | grep -q -e '^lua-resty-openidc$' ; then \
      luarocks list --outdated ; \
      exit 1 ; \
    fi

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
    && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
