# openid-connect-provider-debugger (image build context)

Build context for the container image that debugs OpenID Connect providers. It
is an OpenResty (nginx + Lua) service that echoes/inspects the OIDC flow.

- `Dockerfile` / `Dockerfile-test` — image and test-image definitions.
- `nginx.conf.patch`, `default.conf` — nginx configuration.
- `*.rockspec`, `luarocks.lock` — the Lua dependencies (OpenResty modules).
- `index.html`, `error.html` — served pages.
- `docker-compose.test.yml` — the container test run in CI.

See the [root README](../README.md) for what the tool does and how to run it.
