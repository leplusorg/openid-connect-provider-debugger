# openid-connect-provider-debugger (image build context)

Build context for the `leplusorg/openid-connect-provider-debugger` container
image. It is an OpenResty (nginx + Lua) service that acts as a minimal OpenID
Connect Relying Party and logs the whole flow. See the
[root readme](../README.md) for what the tool does and how to run it.

## Files

- `Dockerfile` — the image definition, based on the official OpenResty image.
  System packages are pinned to exact versions here.
- `nginx.conf.patch` — applied to OpenResty's `nginx.conf` at build time: logs
  to stderr at debug level, runs the workers as the `openresty` user and
  exposes the `oidc_*` and `page_content_type` environment variables to Lua.
- `default.conf` — the nginx server configuration, installed in
  `/etc/nginx/conf.d/`. It implements the `/debug`, `/login`, `/logout` and
  `/status` endpoints in Lua on top of `lua-resty-openidc`.
- `index.html` — the web UI served at `/`, to enter the provider settings.
- `error.html` — the page served on internal errors.
- `openid-connect-provider-debugger-0.0.0-1.rockspec` — the LuaRocks manifest
  declaring the direct Lua dependencies of the image, without versions. The
  `Dockerfile` installs them with `luarocks install --deps-only`.
- `luarocks.lock` — the pinned versions of all the Lua dependencies, including
  transitive ones. The `Dockerfile` copies it next to the rockspec, so
  `luarocks` installs exactly these versions, and the weekly `Luarocks Check
  Versions` workflow reads it to report outdated packages. To upgrade a
  dependency, edit its version here.
- `docker-compose.test.yml` — the end-to-end test run in CI: starts a
  [Dex](https://dexidp.io/) provider, the debugger configured against it, and
  a test client built from `Dockerfile-test`.
- `Dockerfile-test` — the test client image, which runs `test/e2e.sh`.
- `test/dex.yml` — the Dex configuration (a static client and a mock login
  connector).
- `test/e2e.sh` — the test script: logs in through the debugger and checks
  the resulting tokens and the `/status` output.

## Manifests

The manifest (`luarocks.lock`) exposes the pinned versions of some of the
packages and tools included in the image in a machine-readable format. It can
be used to generate an SBOM. Dependabot and Renovate do not support LuaRocks,
so the `Luarocks Check Versions` workflow checks it for updates instead.
