#!/bin/bash

set -xeo pipefail
shopt -s nullglob

EXTERNAL_IP="${APP_INSTANCE_NAME}-moon"

export EXTERNAL_IP

for test in /tests/*; do
  testrunner -logtostderr "--test_spec=${test}"
done

