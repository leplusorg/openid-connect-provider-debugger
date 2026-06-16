FROM openresty/openresty:1.31.1.1-1-alpine-fat@sha256:acd832254d9c969b8039c64471118f7123c6b77a36095bee70d67dcf13ff9423

ARG USER_NAME=openresty
ARG USER_HOME=/home/openresty
ARG USER_ID=1000
ARG USER_GECOS=OpenResty

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-ifsSL", "http://localhost"]

COPY nginx.conf.patch /usr/local/openresty/nginx/conf/

RUN apk upgrade --no-cache \
    && apk add --no-cache \
    curl=8.19.0-r0 \
    patch=2.8-r0 \
    && apk cache --no-cache clean \
    && rm -rf /var/cache/apk/*

COPY openid-connect-provider-debugger-0.0.0-1.rockspec /tmp/openid-connect-provider-debugger-0.0.0-1.rockspec

RUN luarocks install --deps-only /tmp/openid-connect-provider-debugger-0.0.0-1.rockspec \
    && rm -f /tmp/openid-connect-provider-debugger-0.0.0-1.rockspec

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
