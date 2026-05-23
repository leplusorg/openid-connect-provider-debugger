FROM openresty/openresty:1.29.2.4-1-alpine-fat@sha256:3c7e794b5930b67e9e0d4ac7a298bb9eccce1f7d353c4345655da74bed1fc65d

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

COPY openid-connect-provider-debugger-0.0.0.rockspec /tmp/openid-connect-provider-debugger-0.0.0.rockspec

# We let lua-resty-session get pulled transitively to ensure compatibility
RUN luajit -e 'dofile("/tmp/openid-connect-provider-debugger-0.0.0.rockspec"); for _, dep in ipairs(dependencies) do local package, version = dep:match("^(.+)%s*==%s*(.+)$"); if package and version then print(package .. " " .. version) end end' | while read package version ; do \
      luarocks install "${package}" --pin "${version}" ; \
    done ; \
    rm -f /tmp/openid-connect-provider-debugger-0.0.0.rockspec

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
