#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

docker build -t thomasleplus/openid-connect-provider-debugger $(dirname "${0}")/openid-connect-provider-debugger
