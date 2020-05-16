# openid-connect-provider-debugger
A docker image to test and troubleshoot OpenID Connect Providers (OP) using a simple Relying Party (RP).

![GitHub Build](https://img.shields.io/github/workflow/status/thomasleplus/openid-connect-provider-debugger/Docker%20Image%20CI)
![Docker Stars](https://img.shields.io/docker/stars/thomasleplus/openid-connect-provider-debugger)
![Docker Pulls](https://img.shields.io/docker/pulls/thomasleplus/openid-connect-provider-debugger)
![Docker Automated](https://img.shields.io/docker/cloud/automated/thomasleplus/openid-connect-provider-debugger)
![Docker Build](https://img.shields.io/docker/cloud/build/thomasleplus/openid-connect-provider-debugger)
![Docker Version](https://img.shields.io/docker/v/thomasleplus/openid-connect-provider-debugger?sort=semver)

## Run

To launch the debugger, you willd need to get the following information from the OP:

1. client ID.
1. client secret.
1. discovery URI (usually something like https://www.provider.com/.well-known/openid-configuration).

Also typically your OP will ask you to provide the Redirect URI it should accept (http://localhost:8080/login in our example below).

Once your have provided and gathered the above information, simply run the following docker command:

```
docker run -i -e 'OIDC_CLIENT_ID=<client_secret>' -e 'OIDC_CLIENT_SECRET=<client_id>' -e 'OIDC_DISCOVERY=<discovery_url>' -e 'OIDC_REDIRECT_URI=http://localhost:8080/login' -p 8080:80 thomasleplus/openid-connect-provider-debugger
```

Finally open http://localhost:8080 in your favorite browser and you should be redirected to your OP to begin the authentication flow. Remember that if you are already signed in, you may go through the authentication without any prompt. If you authenticate succesfully, you should see a JSON document containing all the information received by the debugger from the OP. You can find more details (including the raw tokens) in the logs printed by the docker container.

A successful sign in would result in the display of a JSON document like this one:
```
{
	"id_token": {
		"azp": "debugger",
		"iat": 1589647290,
		"iss": "http:\/\/192.168.1.10:8081\/auth\/realms\/master",
		"aud": "debugger",
		"nonce": "82efa38c4a21df2069ab898fdf6e91ea",
		"exp": 1589647350,
		"jti": "cbd96855-59e3-446d-af6e-dda62093716d",
		"sub": "138c94bc-e73b-40a2-93c5-547f16200b01",
		"email_verified": false,
		"acr": "1",
		"preferred_username": "tom",
		"auth_time": 1589647290,
		"session_state": "49cdc3ed-61dc-4d05-be78-3ca23727c35d",
		"typ": "ID"
	},
	"user": {
		"email_verified": false,
		"preferred_username": "tom",
		"sub": "138c94bc-e73b-40a2-93c5-547f16200b01"
	},
	"access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJESXl1cmFIN3VUYVpXQ1I4SWRfWHdwd2FaZmFod2I5TDRaRkg1U3VlYmw0In0.eyJleHAiOjE1ODk2NDczNTAsImlhdCI6MTU4OTY0NzI5MCwiYXV0aF90aW1lIjoxNTg5NjQ3MjkwLCJqdGkiOiJkZTA2ZTcxYi1lMGZmLTQ2NWUtYWZlOS0wODRiN2M1MzI4NGIiLCJpc3MiOiJodHRwOi8vMTkyLjE2OC4xLjEwOjgwODEvYXV0aC9yZWFsbXMvbWFzdGVyIiwiYXVkIjpbIm1hc3Rlci1yZWFsbSIsImFjY291bnQiXSwic3ViIjoiMTM4Yzk0YmMtZTczYi00MGEyLTkzYzUtNTQ3ZjE2MjAwYjAxIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiZGVidWdnZXIiLCJub25jZSI6IjgyZWZhMzhjNGEyMWRmMjA2OWFiODk4ZmRmNmU5MWVhIiwic2Vzc2lvbl9zdGF0ZSI6IjQ5Y2RjM2VkLTYxZGMtNGQwNS1iZTc4LTNjYTIzNzI3YzM1ZCIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiY3JlYXRlLXJlYWxtIiwib2ZmbGluZV9hY2Nlc3MiLCJhZG1pbiIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsibWFzdGVyLXJlYWxtIjp7InJvbGVzIjpbInZpZXctaWRlbnRpdHktcHJvdmlkZXJzIiwidmlldy1yZWFsbSIsIm1hbmFnZS1pZGVudGl0eS1wcm92aWRlcnMiLCJpbXBlcnNvbmF0aW9uIiwiY3JlYXRlLWNsaWVudCIsIm1hbmFnZS11c2VycyIsInF1ZXJ5LXJlYWxtcyIsInZpZXctYXV0aG9yaXphdGlvbiIsInF1ZXJ5LWNsaWVudHMiLCJxdWVyeS11c2VycyIsIm1hbmFnZS1ldmVudHMiLCJtYW5hZ2UtcmVhbG0iLCJ2aWV3LWV2ZW50cyIsInZpZXctdXNlcnMiLCJ2aWV3LWNsaWVudHMiLCJtYW5hZ2UtYXV0aG9yaXphdGlvbiIsIm1hbmFnZS1jbGllbnRzIiwicXVlcnktZ3JvdXBzIl19LCJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ0b20ifQ.NdRCOPxGzJvZYhbfcm7dTrsbcQ4AtsO17hUUDWwdYWEr7lHp4z-b-_xkEUiaAub-JCDpb5EO2EVFl3BaoZZc8eEsdXRQIRrBj-TYVFtcgd362MnZMORuXuP-7YbUsoNeAhAzBTVoDLJVXxK30yMN3vY9JOpxWLm8xxGGbY3QA7ciPq5J_phKjMal9kT-gZaSNMutPwpiR3paKGcgCf3SgurSCJ0jcYfbuGCRYcIHP16dHgtXHNXtuhKx0-WyxFNsX-3i78fQz79iqC5FvQQDqY4YKmbBOV6JBGOjxKyrlndFdLq5U5VkIPhgw9O02owwD35dyRcWRaYTPd3LUZFKWA"
}
```

You can use https://jwt.io to decode the access token.

## Options

Settings are passed to the docker image using environment variables (e.g. using the -e command line option).

### OIDC_CLIENT_ID

Description: the OpenID Connect Client ID.

Mandatory: yes

Default: none

### OIDC_CLIENT_SECRET

Description: the OpenID Connect Client Secret (WARNING: this sensitive value will appear in the logs of the docker so please do not share your logs without redacting this value).

Mandatory: yes

Default: none

### OIDC_DISCOVERY

Description: the URI of the OpenID Connect Provider discovery endpoint (usually a URI ending in something like "/.well-known/openid-configuration").

Mandatory: yes

Default: none

### OIDC_REDIRECT_URI

Description: the OpenID Connect redirect URI (typically if you are running the instance locally on port 8080, it would be http://localhost:8080/login).

Mandatory: yes

Default: none

## Test

To test the debugger (or any other Relying Party), you can use JBoss Keycloak as a local OpenID Connect Provider.

Launch Keycloak using the following command (choosing the desired username and password):
```
docker run -i -e KEYCLOAK_USER=<usename> -e KEYCLOAK_PASSWORD=<password> -p 8081:8080 jboss/keycloak
```

The go to the Keycloak admin console at http://localhost:8081/auth/admin/master/console/#/realms/master/clients and authenticate using the username and password chosen in the above command.

Click the "Create" button to create a new client. Choose a client ID and click "Save". On the next screen, choose the value "confidential" for the "Access Type". Then you need to provice the "Valid Redirect URIs". Put here the value "http://localhost:8080/*" assuming that you will be running the debugger on port 8080 (see "Run" section above for details). Click "Save". Then go to the "Credentials" tab and copy client secret.

Now you can run the debugger (see "Run" section above for details). The client ID is the value that you just chose when creating the client in Keycloak. The client secret is the value that you copied from the Credentials tab. The OpenID Connect Discovery URL will be http://192.168.0.1:8081/auth/realms/master/.well-known/openid-configuration where you need to replace the IP address by your local machine network address. You need to use an IP address that works both from your local machine and from inside the debugger docker container (for the debugger to be able to connect to the OP to retrieve the tokens). This is why you can't use `localhost` or `127.0.0.1`.

## Credits

This project is based on NGINX / OpenResty and all the actual OpenID Connect implemention comes from https://github.com/zmartzone/lua-resty-openidc.

## Alternatives

If all you need is to do a simple test and you do not need to see the details of each HTTP request and response, you can use this online OIDC deubgger: https://oidcdebugger.com. Its source code is available at https://github.com/nbarbettini/oidc-debugger.
