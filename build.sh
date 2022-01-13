#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

dir=$(dirname "${0}")

docker build -t leplusorg/openid-connect-provider-debugger "${dir}/openid-connect-provider-debugger"
