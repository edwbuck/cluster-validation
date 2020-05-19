#!/bin/env bash

set -o pipefail

[[ ! -n ${LOG_FILE_PATH} ]] && { echo "LOG_FILE_PATH unset, exiting now"; exit 1; }

COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[0;32m'
COLOR_BOLD='\033[1m'
COLOR_RESET='\033[0m'

function log() {
  echo -e "$@"
  echo -e "$@" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >> ${LOG_FILE_PATH}
}

function log_verbose() {
    [[ "${VERBOSE}" == "true" ]] && log $@
}

function log_no_newline() {
    echo -ne "$@"
    echo -ne "$@" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >> ${LOG_FILE_PATH}
}

function log_file() {
    echo "$@" >> ${LOG_FILE_PATH}
}

function log_red() {
    log "${COLOR_RED}$@${COLOR_RESET}"
}

function log_yellow() {
    log "${COLOR_YELLOW}$@${COLOR_RESET}"
}

function log_green() {
    log "${COLOR_GREEN}$@${COLOR_RESET}"
}

function log_bold() {
    log "${COLOR_BOLD}$@${COLOR_RESET}"
}

function log_error() {
    log_red "ERROR: $@"
}

function log_warning() {
    log_yellow "WARNING: $@"
}
