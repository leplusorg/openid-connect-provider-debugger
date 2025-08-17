# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.27.1.2-3-alpine-fat@sha256:eb0d368d262cc82b867d88f48b49a93ad9247436b65d459a14940d28ccd0e67b

ARG LUA_RESTY_OPENIDC_VERSION="1.8.0-1"

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-ifsSL", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

# hadolint ignore=DL3019
RUN apk -U upgrade \
    && apk add \
    curl=8.12.1-r1 \
    patch=2.7.6-r10 \
    && if apk -u list | tee -a /dev/stderr | grep -q -e . ; then \
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
    && if luarocks list --outdated  | tee -a /dev/stderr | grep -q -e '^lua-resty-openidc$' ; then \
      exit 1 ; \
    fi

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
    && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
