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
EXTRA_VARS={\"${TEMPLATE_VAR}\":\"${TEMPLATE_VAR_VALUE}\"}
awx job_templates launch --monitor -e ${EXTRA_VARS} "${TEMPLATE}"
