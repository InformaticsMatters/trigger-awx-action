#!/bin/sh -l

# Given the following arguments: -
#
# - Template Name
# - Template Host
# - Template User
# - Template User Password
# - Template Variable
# - Template Variable value
#
# this script uses the tower-cli to run a template
# on an AWX server.

TEMPLATE=$1
export CONTROLLER_HOST=$2
export CONTROLLER_USERNAME=$3
export CONTROLLER_PASSWORD=$4
TEMPLATE_VAR=$5
TEMPLATE_VAR_VALUE=$6

echo "Launching Job Template ${TEMPLATE} and monitoring..."
# Only inject a template variable if one has been provided.
# When no template variable is given we launch the template without
# any extra variables.
# We redirect stdout to /dev/null
# otherwise sensitive AWX variables may be exposed to the GitHub Action Log
if [ -n "${TEMPLATE_VAR}" ]; then
  EXTRA_VARS={\"${TEMPLATE_VAR}\":\"${TEMPLATE_VAR_VALUE}\"}
  echo "EXTRA_VARS=${EXTRA_VARS}"
  awx job_templates launch --monitor -e ${EXTRA_VARS} "${TEMPLATE}" > /dev/null
else
  echo "No template variable provided - launching without extra variables"
  awx job_templates launch --monitor "${TEMPLATE}" > /dev/null
fi
