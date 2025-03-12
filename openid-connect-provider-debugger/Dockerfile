# checkov:skip=CKV_DOCKER_3
FROM openresty/openresty:1.27.1.1-alpine-fat@sha256:aa8ea52fa35a296558aed8b392fb39d575e39dd4a7717fa44f1fd6fc09c1185d

ARG LUA_RESTY_OPENIDC_VERSION="1.8.0-1"

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-i", "-s", "-S", "-f", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

# hadolint ignore=DL3019
RUN apk -U upgrade \
    && apk add \
    curl=8.12.1-r0 \
    patch=2.7.6-r10 \
    && if apk -u list | grep -q -e . ; then \
      apk -u list ; \
      exit 1 ; \
    fi \
    && rm -rf /var/cache/apk/*

# We let lua-resty-session get pulled transitively to ensure compatibility
RUN luarocks install lua-resty-openidc --pin "${LUA_RESTY_OPENIDC_VERSION}" \
    && if luarocks list --outdated | grep -q -e '^lua-resty-openidc$' ; then \
      luarocks list --outdated ; \
      exit 1 ; \
    fi

RUN patch /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.patch \
    && rm -f /usr/local/openresty/nginx/conf/nginx.conf.patch

COPY default.conf /etc/nginx/conf.d/

COPY index.html error.html /usr/local/openresty/nginx/html/

EXPOSE 80 443
