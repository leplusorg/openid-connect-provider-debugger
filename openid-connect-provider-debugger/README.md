# openid-connect-provider-debugger (image build context)

Build context for the container image that debugs OpenID Connect providers. It
is an OpenResty (nginx + Lua) service that echoes/inspects the OIDC flow.

- `Dockerfile` / `Dockerfile-test` — image and test-image definitions.
- `nginx.conf.patch`, `default.conf` — nginx configuration.
- `*.rockspec`, `luarocks.lock` — the Lua dependencies (OpenResty modules).
- `index.html`, `error.html` — served pages.
- `docker-compose.test.yml` — the end-to-end test run in CI (debugger + Dex).
- `test/` — the Dex configuration and the end-to-end test script.

See the [root readme](../README.md) for what the tool does and how to run it.
