FROM openresty/openresty:1.29.2.4-0-alpine-fat@sha256:af355ebd6f01e580823b6718e8a2e39be3b45d9437fc92144e43ac72020f7461

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
