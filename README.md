# OpenID Connect provider debugger

A docker image to test and troubleshoot OpenID Connect (OIDC) Providers (OP) using a simple Relying Party (RP).

[![ShellCheck](https://github.com/thomasleplus/openid-connect-provider-debugger/workflows/ShellCheck/badge.svg)](https://github.com/thomasleplus/openid-connect-provider-debugger/actions?query=workflow:"ShellCheck")
[![Docker Build](https://github.com/thomasleplus/openid-connect-provider-debugger/workflows/Docker/badge.svg)](https://github.com/thomasleplus/openid-connect-provider-debugger/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/thomasleplus/openid-connect-provider-debugger)](https://hub.docker.com/r/thomasleplus/openid-connect-provider-debugger)
[![Docker Pulls](https://img.shields.io/docker/pulls/thomasleplus/openid-connect-provider-debugger)](https://hub.docker.com/r/thomasleplus/openid-connect-provider-debugger)
[![Docker Automated](https://img.shields.io/docker/cloud/automated/thomasleplus/openid-connect-provider-debugger)](https://hub.docker.com/r/thomasleplus/openid-connect-provider-debugger)
[![Docker Build](https://img.shields.io/docker/cloud/build/thomasleplus/openid-connect-provider-debugger)](https://hub.docker.com/r/thomasleplus/openid-connect-provider-debugger)
[![Docker Version](https://img.shields.io/docker/v/thomasleplus/openid-connect-provider-debugger?sort=semver)](https://hub.docker.com/r/thomasleplus/openid-connect-provider-debugger)

## Run

To launch the debugger, you will need to get the following information from the OP:

1. client ID.
1. client secret.
1. discovery URI (usually something like https://www.provider.com/.well-known/openid-configuration).

Also typically your OP will ask you to provide the Redirect URI it should accept (http://localhost:8080/login in our example below).

### Using the web UI

Once your have provided and gathered the above information, run the following docker:

```
docker run -i -p 8080:80 thomasleplus/openid-connect-provider-debugger
```

Finally, open http://localhost:8080 in your favorite browser and follow the instruction on the web page.

You should be redirected to your OP to begin the authentication flow. Remember that if you are already signed in, you may go through the authentication without any prompt. If you authenticate successfully, you should see a JSON document containing all the information received by the debugger from the OP. You can find more details (including the raw tokens) in the logs printed by the docker container.

A successful sign in would result in the display of a JSON document like this one:
```
{
	"options": {
		"client_id": "debugger",
		"discovery": "http:\/\/192.168.1.10:8081\/auth\/realms\/master\/.well-known\/openid-configuration",
		"redirect_uri": "http:\/\/localhost:8080\/login",
		"ssl_verify": "no",
		"client_secret": "835e0717-e0c8-4b57-b044-295fa0e3f61b"
	},
	"id_token": {
		"azp": "debugger",
		"iat": 1590619714,
		"iss": "http:\/\/192.168.1.10:8081\/auth\/realms\/master",
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
	"access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJwbjdtd1B1WDZ5ZjBvSHEtTDFiZ2l6T2FVeGs5aDlGaU8ycjlMcV9LYkNRIn0.eyJleHAiOjE1OTA2MTk3NzQsImlhdCI6MTU5MDYxOTcxNCwiYXV0aF90aW1lIjoxNTkwNjE5NzE0LCJqdGkiOiI5MTk0ODgxZS05ZGMzLTQ1YjItOWExOS1mZDFlZTk3NDY4NjciLCJpc3MiOiJodHRwOi8vMTkyLjE2OC4xLjEwOjgwODEvYXV0aC9yZWFsbXMvbWFzdGVyIiwiYXVkIjpbIm1hc3Rlci1yZWFsbSIsImFjY291bnQiXSwic3ViIjoiMzhiNGEyOTAtNTMzMi00YzRjLWJiOGYtNDZlYjI4MjZjN2VhIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiZGVidWdnZXIiLCJub25jZSI6IjFlMjM1MzdiYjA2ZjJiNGUzMjRkMTJkOGQ1MWYyYzZiIiwic2Vzc2lvbl9zdGF0ZSI6ImZiM2VkY2MyLWY1YjMtNDdmYS04NGY2LTYwY2JhZTc5MmNkZSIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiY3JlYXRlLXJlYWxtIiwib2ZmbGluZV9hY2Nlc3MiLCJhZG1pbiIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsibWFzdGVyLXJlYWxtIjp7InJvbGVzIjpbInZpZXctcmVhbG0iLCJ2aWV3LWlkZW50aXR5LXByb3ZpZGVycyIsIm1hbmFnZS1pZGVudGl0eS1wcm92aWRlcnMiLCJpbXBlcnNvbmF0aW9uIiwiY3JlYXRlLWNsaWVudCIsIm1hbmFnZS11c2VycyIsInF1ZXJ5LXJlYWxtcyIsInZpZXctYXV0aG9yaXphdGlvbiIsInF1ZXJ5LWNsaWVudHMiLCJxdWVyeS11c2VycyIsIm1hbmFnZS1ldmVudHMiLCJtYW5hZ2UtcmVhbG0iLCJ2aWV3LWV2ZW50cyIsInZpZXctdXNlcnMiLCJ2aWV3LWNsaWVudHMiLCJtYW5hZ2UtYXV0aG9yaXphdGlvbiIsIm1hbmFnZS1jbGllbnRzIiwicXVlcnktZ3JvdXBzIl19LCJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ0b20ifQ.NCFiSW3Tt7qQCtE8g46kLg-oSqKiDseg4NCwV1kVPoD5yFa9XunooVE3eO1XgKACb_FFzrxEMYfmStpvypI7VFu-XO5ULkrbXElhDtMmVbEn-aqNILHs_h_Ewo1JdCa-gNL9zav5QhmcwmIUpNYsDsQxm-bN86JgQO2f8ZJ497K6DpPFnIrhd0eT0fa4iw7Tx64PdIDUPXqqYrR2nh0P-D0dkkVTSu-EI14uuwwClYy5Pq9EeKfX9M8SqUp81gprhty-9PneDcFjBpEgFRCfFhecSBn0_c1urlx5QTbN96PnCWlH2t-aGLfRHD8oJcv-xztHt02Zhy-L2B3z-bCfSQ"
}
```

You can use https://jwt.io to decode the access token.

### Using URL parameters

If you prefer to skip the UI, you can pass directly the required values as URL parameters using the following syntax: http://localhost:8080/debug?oidc_client_id=client_id&oidc_client_secret=client_secret&oidc_discovery=discovery_url&oidc_redirect_uri=redirect_uri

See section "Parameters" below for a description of each parameter.

Remember to URL encode the parameter values if they contain any reserved characters ('&', '?', '/' etc.).

### Using environment variables

You can pass the parameters to the docker container using environment variales like this:

```
docker run -i -e 'oidc_client_id=<client_id>' -e 'oidc_client_secret=<client_secret>' -e 'oidc_discovery=<discovery_url>' -e 'oidc_redirect_uri=http://localhost:8080/login' -p 8080:80 thomasleplus/openid-connect-provider-debugger
```

See section "Parameters" below for a description of each parameter.

Then go to http://localhost:8080/debug to skip the UI and initiate the authentication flow.

## Parameters

Settings are passed to the docker image using environment variables (e.g. using the -e command line option) or directly to NGINX using URL parameters.

### oidc_client_id

Description: the OpenID Connect Client ID.

Mandatory: yes

Default: none

### oidc_client_secret

Description: the OpenID Connect Client Secret (WARNING: this sensitive value will appear in the logs of the docker so please do not share your logs without redacting this value).

Mandatory: yes

Default: none

### oidc_discovery

Description: the URI of the OpenID Connect Provider discovery endpoint (usually a URI ending in something like "/.well-known/openid-configuration").

Mandatory: yes

Default: none

### oidc_redirect_uri

Description: the OpenID Connect redirect URI (typically if you are running the instance locally on port 8080, it would be http://localhost:8080/login).

Mandatory: yes

Default: none

## Test

To test the debugger (or any other Relying Party), you can use JBoss Keycloak as a local OpenID Connect Provider.

Launch Keycloak using the following command (choosing the desired username and password):
```
docker run -i -e KEYCLOAK_USER=<usename> -e KEYCLOAK_PASSWORD=<password> -p 8081:8080 jboss/keycloak
```

Then go to the Keycloak admin console at http://localhost:8081/auth/admin/master/console/#/realms/master/clients and authenticate using the username and password chosen in the above command.

Click the "Create" button to create a new client. Choose a client ID and click "Save". On the next screen, choose the value "confidential" for the "Access Type". Then you need to provide the "Valid Redirect URIs". Put here the value "http://localhost:8080/*" assuming that you will be running the debugger on port 8080 (see "Run" section above for details). Click "Save". Then go to the "Credentials" tab and copy the client secret.

Now you can run the debugger (see "Run" section above for details). The client ID is the value that you just chose when creating the client in Keycloak. The client secret is the value that you copied from the Credentials tab. The OpenID Connect Discovery URL will be http://192.168.0.1:8081/auth/realms/master/.well-known/openid-configuration where you need to replace the IP address by your local machine network address. You need to use an IP address that works both from your local machine and from inside the debugger docker container (for the debugger to be able to connect to the OP to retrieve the tokens). This is why you can't use `localhost` or `127.0.0.1`.

## Credits

This project is based on NGINX / OpenResty and all the actual OpenID Connect implementation comes from https://github.com/zmartzone/lua-resty-openidc.

## Alternatives

If all you need is to do a simple test and you do not need to see the details of each HTTP request and response, you can use this online OIDC debugger: https://oidcdebugger.com. Its source code is available at https://github.com/nbarbettini/oidc-debugger.

Another alternative is the official OpenID Foundation certification tests that can be run online at https://op.certification.openid.net:60000 and https://rp.certification.openid.net:8080, the source code being available at https://github.com/openid-certification/oidctest.
