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
TEMPLATE_HOST=$2
TEMPLATE_USER=$3
TEMPLATE_USER_PASSWORD=$4
TEMPLATE_VAR=$5
TEMPLATE_VAR_VALUE=$6

# Get the AWX Job Template ID from the Job Template name
jtid=$(tower-cli job_template list -n "${TEMPLATE}" -f id \
  -h "${TEMPLATE_HOST}" \
  -u "${TEMPLATE_USER}" \
  -p "${TEMPLATE_USER_PASSWORD}")

# If we have a template ID (i.e. a number) then trigger it
# and disable any input that might be expected by the Job.
EXTRA_VARS="${TEMPLATE_VAR}=\'${TEMPLATE_VAR_VALUE}\'"
if echo "${jtid}" | grep -Eq '^[0-9]+$'; then
  echo "Launching Job ID ${jtid} and waiting..."
  tower-cli job launch -J "${jtid}" --no-input --wait \
    -h "${TEMPLATE_HOST}" \
    -u "${TEMPLATE_USER}" \
    -p "${TEMPLATE_USER_PASSWORD}" \
    -e "${EXTRA_VARS}"
else
  echo "Job Template '${TEMPLATE}' does not exist (${jtid})"
  exit 1
fi
