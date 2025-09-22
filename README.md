# OpenID Connect provider debugger

A Docker image to test and troubleshoot OpenID Connect (OIDC)
Providers (OP). This containers provides a minimalist Relying Party
(RP) with verbose logs enabled including all HTTP requests and
responses. Used in conjuction with the network logs of your web
browser, it provides a full picture of the OP's behavior to help
understand and troubleshoot the OIDC flow.

[![Dockerfile](https://img.shields.io/badge/GitHub-Dockerfile-blue)](openid-connect-provider-debugger/Dockerfile)
[![Docker Build](https://github.com/leplusorg/openid-connect-provider-debugger/workflows/Docker/badge.svg)](https://github.com/leplusorg/openid-connect-provider-debugger/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/leplusorg/openid-connect-provider-debugger)](https://hub.docker.com/r/leplusorg/openid-connect-provider-debugger)
[![Docker Pulls](https://img.shields.io/docker/pulls/leplusorg/openid-connect-provider-debugger)](https://hub.docker.com/r/leplusorg/openid-connect-provider-debugger)
[![Docker Version](https://img.shields.io/docker/v/leplusorg/openid-connect-provider-debugger?sort=semver)](https://hub.docker.com/r/leplusorg/openid-connect-provider-debugger)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/10077/badge)](https://bestpractices.coreinfrastructure.org/projects/10077)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/leplusorg/openid-connect-provider-debugger/badge)](https://securityscorecards.dev/viewer/?uri=github.com/leplusorg/openid-connect-provider-debugger)

## Run

To launch the debugger, you will need to get the following information from the OP:

1. client ID.
1. client secret.
1. discovery URI (usually something like <https://www.provider.com/.well-known/openid-configuration>).

Also typically your OP will ask you to provide the Redirect URI it
should accept (<http://localhost:8080/login> in our example below).

### Using the web UI

Once your have provided and gathered the above information, run the
following Docker command:

```bash
docker run -i -p 127.0.0.1:8080:80 leplusorg/openid-connect-provider-debugger
```

Finally, open <http://localhost:8080> in your favorite browser and
follow the instruction on the web page.

You should be redirected to your OP to begin the authentication
flow. Remember that if you are already signed in, you may go through
the authentication without any prompt. If you authenticate
successfully, you should see a JSON document containing all the
information received by the debugger from the OP. You can find more
details (including the raw tokens) in the logs printed by the Docker
container.

A successful sign in would result in the display of a JSON document like this one:

```json
{
  "options": {
    "client_id": "debugger",
    "discovery": "http://192.168.0.1:8081/realms/master/.well-known/openid-configuration",
    "redirect_uri": "http://localhost:8080/login",
    "ssl_verify": "no",
    "client_secret": "835e0717-e0c8-4b57-b044-295fa0e3f61b"
  },
  "id_token": {
    "azp": "debugger",
    "iat": 1590619714,
    "iss": "http://192.168.0.1:8081/realms/master",
    "aud": "debugger",
    "nonce": "1e23537bb06f2b4e324d12d8d51f2c6b",
    "exp": 1590619774,
    "jti": "9a1b5cf6-87ab-4557-a4aa-b771a67af1db",
    "sub": "38b4a290-5332-4c4c-bb8f-46eb2826c7ea",
    "email_verified": false,
    "acr": "1",
    "preferred_username": "tom",
    "auth_time": 1590619714,
    "session_state": "fb3edcc2-f5b3-47fa-84f6-60cbae792cde",
    "typ": "ID"
  },
  "user": {
    "email_verified": false,
    "preferred_username": "tom",
    "sub": "38b4a290-5332-4c4c-bb8f-46eb2826c7ea"
  },
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSl...",
  "id_token_encoded": "eyJhbGciOiJIUzI1NiIsInR5cCI6Ikwv3Y..."
}
```

You can use <https://jwt.io> to decode the access token.

### Using URL parameters

If you prefer to skip the UI, you can pass directly the required
values as URL parameters using the following syntax:
<http://localhost:8080/debug?oidc_client_id=debugger&oidc_client_secret=secret&oidc_discovery=http%3A%2F%2F192.168.0.1%3A8081%2Frealms%2Fmaster%2F.well-known%2Fopenid-configuration&oidc_redirect_uri=http://localhost:8080/login>

See section "Parameters" below for a description of each parameter.

Remember to URL encode the parameter values if they contain any
reserved characters ('&', '?', '/' etc.).

### Using environment variables

You can pass the parameters to the Docker container using environment
variales like this:

```bash
docker run -i -e 'oidc_client_id=debugger' -e 'oidc_client_secret=secret' -e 'oidc_discovery=http://192.168.0.1:8081/realms/master/.well-known/openid-configuration' -e 'oidc_redirect_uri=http://localhost:8080/login' -p 127.0.0.1:8080:80 leplusorg/openid-connect-provider-debugger
```

See section "Parameters" below for a description of each parameter.

Then go to <http://localhost:8080/debug> to skip the UI and initiate
the authentication flow.

## Parameters

Settings are passed to the Docker image using environment variables
(e.g. using the -e command-line option) or directly to NGINX using URL
parameters.

### oidc_client_id

Description: the OpenID Connect Client ID.

Mandatory: yes

Default: none

### oidc_client_secret

Description: the OpenID Connect Client Secret (WARNING: this sensitive
value will appear in the logs of the Docker so please do not share
your logs without redacting this value).

Mandatory: yes

Default: none

### oidc_discovery

Description: the URI of the OpenID Connect Provider discovery endpoint
(usually a URI ending in something like
"/.well-known/openid-configuration").

Mandatory: yes

Default: none

### oidc_redirect_uri

Description: the OpenID Connect redirect URI (typically if you are
running the instance locally on port 8080, it would be
<http://localhost:8080/login>).

Mandatory: yes

Default: none

### oidc_scope

Description: the OpenID Connect scope (e.g. "openid email profile").

Mandatory: no

Default: "openid email profile" (coming from the <https://github.com/zmartzone/lua-resty-openidc> dependency).

### oidc_post_logout_uri

Description: the OpenID Connect post_logout_redirect_uri (if you running the
instance locally on port 8080, it could be <http://localhost:8080/status>).
You might have to configure this URI in the OP's admin console.

Mandatory: no

Default: none.

### page_content_type

Description: the content type of the resulting JSON (e.g. `application/json`).
E.g. for cypress tests you might want to set this to `text/html`.
Note: this does not change the content of the result only the content-type header.

Mandatory: no

Default: `application/json`

## Endpoints

The following endpoints are available: `/debug`, `/login`, `/logout`, `/status`

`/debug` is used to initiate and end the OpenID Connect flow. If the
user is authenticated, it will display the JSON document containing the
tokens and user information.

`/login` is the redirect URI where the OP will send the user after
authentication. It will build up the session state and redirect the
user back to the /debug endpoint.

`/logout` is used to end the session and log the user out of the OP.
If a post_logout_redirect_uri (oidc_post_logout_uri argument) is
provided, the user will be redirected to that URL from the OP.

`/status` is a simple page that displays the current session state as a
JSON document. There are three possible states: "not_authenticated",
"authenticated" and "session_active_but_no_user". This might be a good
place for a post_logout_redirect_uri.

Note: `/debug`, `/login` and `/logout` share all the same code. `/debug`
and `/login` behave absolutely identical, while `/logout` behaves
differently because of the used OIDC lua library.

## Testing

To test the debugger (or any other Relying Party), you can use JBoss
Keycloak as a local OpenID Connect Provider.

Launch Keycloak using the following command (choosing the desired
username and password):

```bash
docker run -i -e 'KC_BOOTSTRAP_ADMIN_USERNAME=admin' -e 'KC_BOOTSTRAP_ADMIN_PASSWORD=admin' -p 0.0.0.0:8081:8080 quay.io/keycloak/keycloak:latest start-dev
```

Here we use the IP address `0.0.0.0` to expose Keycloak on both
`localhost` (`127.0.0.0.1`) and on your machine's public IP because we
will need to use that public IP to access it from the
openid-connect-provider-debugger Docker instance. We cannot use
`localhost` because it would be interpreted by the
openid-connect-provider-debugger instance as referring to itself
instead of the `localhost` of the host where Keycloak's port is
mapped. **If your host is running a firewall (as it should), this means
that you probably need to allow incoming connections to Keycloak's
port (`8081` in our example) on your public IP.** Ideally your
firewall should let you allow only connection from and to the same
public IP so that you don't expose Keycloak to your whole local
network.

Next go to the Keycloak's admin console at
<http://localhost:8081/admin/master/console/#/master/clients>
and authenticate using the username and password chosen in the above
command.

Click the "Create client" button to create a new client. Choose a
client ID (e.g. "debugger") and click "Next". On the next screen,
toggle on the Client authentication then click Next again. Then on the
final screen you need to provide the "Valid Redirect URIs". Put here
the value <http://localhost:8080/*> assuming that you will be running
the debugger on port 8080 (see "Run" section above for details). Click
"Save". Then go to the "Credentials" tab and copy the client secret.

Now you can run the debugger (see "Run" section above for
details). The client ID is the value that you just chose when creating
the client in Keycloak. The client secret is the value that you copied
from the Credentials tab. The OpenID Connect Discovery URL will be
<http://192.168.0.1:8081/realms/master/.well-known/openid-configuration>
where you need to replace the IP address `192.168.0.1` by your local
machine network address. You need to use an IP address that works from
inside the debugger Docker container (for the debugger to be able to
connect to the OP to get the discovery metadata and later retrieve the
tokens). This is why you can't use `localhost` or `127.0.0.1` which
the debugger would interpret as itself instead of the provider.

## Software Bill of Materials (SBOM)

To get the SBOM for the latest image (in SPDX JSON format), use the
following command:

```bash
docker buildx imagetools inspect leplusorg/openid-connect-provider-debugger --format '{{ json (index .SBOM "linux/amd64").SPDX }}'
```

Replace `linux/amd64` by the desired platform (`linux/amd64`, `linux/arm64` etc.).

### Sigstore

[Sigstore](https://docs.sigstore.dev) is trying to improve supply
chain security by allowing you to verify the origin of an
artifcat. You can verify that the image that you use was actually
produced by this repository. This means that if you verify the
signature of the Docker image, you can trust the integrity of the
whole supply chain from code source, to CI/CD build, to distribution
on Maven Central or whever you got the image from.

You can use the following command to verify the latest image using its
sigstore signature attestation:

```bash
cosign verify leplusorg/openid-connect-provider-debugger --certificate-identity-regexp 'https://github\.com/leplusorg/openid-connect-provider-debugger/\.github/workflows/.+' --certificate-oidc-issuer 'https://token.actions.githubusercontent.com'
```

The output should look something like this:

```text
Verification for index.docker.io/leplusorg/xml:main --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - Existence of the claims in the transparency log was verified offline
  - The code-signing certificate was verified using trusted certificate authority certificates

[{"critical":...
```

For instructions on how to install `cosign`, please read this [documentation](https://docs.sigstore.dev/cosign/system_config/installation/).

## Credits

This project is based on NGINX / OpenResty and all the actual OpenID
Connect implementation comes from
<https://github.com/zmartzone/lua-resty-openidc>.

## Alternatives

If all you need is to do a simple test and you do not need to see the
details of each HTTP request and response, you can use this online
[OIDC debugger](https://oidcdebugger.com) with the corresponding
[source code](https://github.com/nbarbettini/oidc-debugger).

Auth0 also provides a web-hosted [OpenID Connect Playground](https://openidconnect.net).

Another alternative is the official OpenID Foundation certification
tests that can be run online at
<https://op.certification.openid.net:60000> and
<https://rp.certification.openid.net:8080>, with the corresponding
[source code](https://github.com/openid-certification/oidctest).
