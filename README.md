# openid-connect-idp-debugger
A docker image to test OpenID Connect Identity Providers (IdP) using a simple Relying Party (RP).

## Run

To launch the debugger, you willd need to get the following information from the IdP:

1. client ID.
1. client secret.
1. discovery URL (usually something like https://www.idp.com/.well-known/openid-configuration).

Also typically your IdP will ask you to provide the Reidrect URI it should accept (http://localhost:8080/login in our example below).

Once your have provided and gathered the above information, simply run the following docker command:

```
docker run -i -e 'OIDC_CLIENT_ID=<client_secret>' -e 'OIDC_CLIENT_SECRET=<client_id>' -e 'OIDC_DISCOVERY=<discovery_url>' -e 'OIDC_REDIRECT_URI=http://localhost:8080/login' -e 'OIDC_SSL_VERIFY=no' -p 8080:80 thomasleplus/openid-connect-idp-debugger
```

Finally open http://localhost:8080 in your favorite browser and you should be redirected to your IdP to begin the authentication flow. Remember that if you are already signed in, you may go through the authentication without any prompt. If you authenticate succesfully, you should see a JSON document containing all the information received by the debugger from the IdP. You can find more details in the logs printed by the docker container.

## Credit

This project is based on NGINX / OpenResty and all the actual OpenID Connect implemention comes from https://github.com/zmartzone/lua-resty-openidc.
