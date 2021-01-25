#!/bin/env bash

set -o pipefail

[[ ! -n ${LOG_FILE_PATH} ]] && { echo "LOG_FILE_PATH unset, exiting now"; exit 1; }

COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[0;32m'
COLOR_BOLD='\033[1m'
COLOR_RESET='\033[0m'

export LOG_INDENTATION=""

function log_indent() {
  # match with log_unindent
  LOG_INDENTATION+="  "
}

function log_unindent() {
  LOG_INDENTATION="${LOG_INDENTATION%??}"
}

function log_indentation() {
  echo -ne "${LOG_INDENTATION}"
  echo -ne "$" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >> ${LOG_FILE_PATH}
}

function log_noindent() {
  echo -e "$@"
  echo -e "$@" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >> ${LOG_FILE_PATH}
}

function log_noindent_nonewline() {
  echo -ne "$@"
  echo -ne "$@" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >> ${LOG_FILE_PATH}
}

function log() {
  echo -e "${LOG_INDENTATION}$@"
  echo -e "${LOG_INDENTATION}$@" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >> ${LOG_FILE_PATH}
}

function log_nonewline() {
  echo -ne "${LOG_INDENTATION}$@"
  echo -ne "${LOG_INDENTATION}$@" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >> ${LOG_FILE_PATH}
}

function log_verbose() {
    [[ "${VERBOSE}" == "true" ]] && log $@
}

function log_file() {
    echo "${LOG_INDENTATION}$@" >> ${LOG_FILE_PATH}
}

function log_yellow() {
    log_noindent_nonewline "${COLOR_YELLOW}$@${COLOR_RESET}"
}

function log_green() {
    log_noindent_nonewline "${COLOR_GREEN}$@${COLOR_RESET}"
}

function log_bold() {
    log_noindent_nonewline "${COLOR_BOLD}$@${COLOR_RESET}"
}

function log_red() {
    log_noindent_nonewline "${COLOR_RED}$@${COLOR_RESET}"
}

function log_error() {
    log_red "ERROR: $@"
    log
}

function log_warning() {
    log_yellow "WARNING: $@"
    log
}
