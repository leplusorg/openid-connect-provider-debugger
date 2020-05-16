# openid-connect-idp-debugger
A docker image to test OpenID Connect Identity Providers (IdP) using a simple Relying Party (RP).

## Run

To launch the debugger, you willd need to get the following information from the IdP:

1. client ID.
1. client secret.
1. discovery URI (usually something like https://www.idp.com/.well-known/openid-configuration).

Also typically your IdP will ask you to provide the Reidrect URI it should accept (http://localhost:8080/login in our example below).

Once your have provided and gathered the above information, simply run the following docker command:

```
docker run -i -e 'OIDC_CLIENT_ID=<client_secret>' -e 'OIDC_CLIENT_SECRET=<client_id>' -e 'OIDC_DISCOVERY=<discovery_url>' -e 'OIDC_REDIRECT_URI=http://localhost:8080/login' -p 8080:80 thomasleplus/openid-connect-idp-debugger
```

Finally open http://localhost:8080 in your favorite browser and you should be redirected to your IdP to begin the authentication flow. Remember that if you are already signed in, you may go through the authentication without any prompt. If you authenticate succesfully, you should see a JSON document containing all the information received by the debugger from the IdP. You can find more details in the logs printed by the docker container.

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

Description: the URI of the OpenID Connect Identity Provider discovery endpoint (usually a URI ending in something like "/.well-known/openid-configuration").

Mandatory: yes

Default: none

### OIDC_REDIRECT_URI

Description: the OpenID Connect redirect URI (typically if you are running the instance locally on port 8080, it would be http://localhost:8080/login).

Mandatory: yes

Default: none

## Credits

This project is based on NGINX / OpenResty and all the actual OpenID Connect implemention comes from https://github.com/zmartzone/lua-resty-openidc.
