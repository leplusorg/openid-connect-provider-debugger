FROM openresty/openresty:1.27.1.2-5-alpine-fat@sha256:93ef9740bc88601961162153605ba67e545b73ee813aa8fedc27cbffc106bea2

ARG LUA_RESTY_OPENIDC_VERSION="1.8.0-1"
ARG USER_NAME=openresty
ARG USER_HOME=/home/openresty
ARG USER_ID=1000
ARG USER_GECOS=OpenResty

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-ifsSL", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

RUN apk upgrade --no-cache \
    && apk add --no-cache \
    curl=8.14.1-r2 \
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

RUN adduser \
  --home "${USER_HOME}" \
  --uid "${USER_ID}" \
  --gecos "${USER_GECOS}" \
  --disabled-password \
  "${USER_NAME}" \
  && chown -R "${USER_NAME}:${USER_NAME}" /var/run/openresty /usr/local/openresty/nginx/logs

USER "${USER_NAME}"

ENV HOME="${USER_HOME}"

WORKDIR "${HOME}"

EXPOSE 80 443
