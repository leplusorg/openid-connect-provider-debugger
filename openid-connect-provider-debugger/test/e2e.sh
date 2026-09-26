#!/bin/sh
# End-to-end test: log in through the debugger against the Dex provider defined
# in docker-compose.test.yml and check the debugger output.
# jq variables such as $iss must not be expanded by the shell:
# shellcheck disable=SC2016

set -eu

base_url=http://localhost
issuer=http://dex:5556/dex
client_id=debugger
# Dex mockCallback connector user
email=kilgore@kilgore.trout

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

# Checks a jq expression against a JSON document, printing the document if the
# check fails.
check() {
	json="$1"
	description="$2"
	shift 2
	if ! echo "${json}" | jq -e "$@" >/dev/null; then
		echo "${json}" | jq . >&2 || echo "${json}" >&2
		fail "${description}"
	fi
	echo "OK: ${description}"
}

cookie_jar="$(mktemp)"
trap 'rm -f "${cookie_jar}"' EXIT

curl -fsS -o /dev/null "${base_url}/" || fail "home page is not served"
echo "OK: home page is served"

status="$(curl -sS --fail-with-body "${base_url}/status")" ||
	fail "status endpoint failed without session: ${status}"
check "${status}" "status is not_authenticated without session" \
	'.status == "not_authenticated"'

# Follow the full authorization code flow like a browser would:
# /debug -> Dex /auth -> Dex mock connector -> /login?code=... -> /debug
result="$(curl -sSL --fail-with-body --max-redirs 10 \
	-c "${cookie_jar}" -b "${cookie_jar}" "${base_url}/debug")" ||
	fail "OpenID Connect flow failed: ${result}"
check "${result}" "id_token is issued by Dex for the debugger client" \
	--arg iss "${issuer}" --arg aud "${client_id}" \
	'.id_token.iss == $iss and ([.id_token.aud] | flatten | index($aud) != null)'
check "${result}" "id_token belongs to the mock user" \
	--arg email "${email}" \
	'.id_token.email == $email and (.id_token.sub | length > 0)'
check "${result}" "encoded id_token is included" \
	'.id_token_encoded | split(".") | length == 3'
check "${result}" "access_token is issued and decoded" \
	--arg iss "${issuer}" \
	'(.access_token | length > 0) and .access_token_jwt_payload_decoded.iss == $iss'
check "${result}" "userinfo matches the id_token" \
	--arg email "${email}" \
	'.user.sub == .id_token.sub and .user.email == $email'
check "${result}" "options used for the flow are included" \
	--arg client_id "${client_id}" \
	'.options.client_id == $client_id and .options.redirect_uri == "http://localhost/login"'

sub="$(echo "${result}" | jq -r '.id_token.sub')"
status="$(curl -sS --fail-with-body -b "${cookie_jar}" "${base_url}/status")" ||
	fail "status endpoint failed with session: ${status}"
check "${status}" "status is authenticated with the logged in user" \
	--arg sub "${sub}" \
	'.status == "authenticated" and .sub == $sub'

echo "All end-to-end checks passed"
