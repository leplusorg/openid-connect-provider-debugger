#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

dir=$(dirname "${0}")

docker build -t thomasleplus/openid-connect-provider-debugger "${dir}/openid-connect-provider-debugger"
