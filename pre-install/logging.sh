#!/bin/env bash

set -o pipefail

[[ ! -n ${LOG_FILE_PATH} ]] && { echo "LOG_FILE_PATH unset, exiting now"; exit 1; }


echo "sourced logging.sh"
