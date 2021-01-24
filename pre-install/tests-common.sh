#!/bin/env bash

[[ ! -n ${SCRIPT_DIR} ]] && { echo "SCRIPT_DIR unset, exiting now"; exit 1; }

source ${SCRIPT_DIR}/logging.sh

TEST_GROUP_NAMES=()
TEST_GROUP_FAILURES=()

function test_group() {
    TEST_GROUP_FAILURES+='false'
    TEST_GROUP_NAMES+=("$@")
    log_indent
    log "$@"
}

function test_group_complete() {
    log_nonewline "${TEST_GROUP_NAMES[-1]}: "
    unset 'TEST_GROUP_NAMES[${#TEST_GROUP_NAMES[@]}-1]'
    if [[ "x${TEST_GROUP_FAILURE}" == "xfalse" ]];
    then
        test_success
    else
        test_failure
    fi
    log_unindent
}

function test_name() {
    log_indent
    log_nonewline "$@: "
    log_unindent
}

function test_success() {
    log_green "SUCCESS"
    if [[ "x$@" != "x" ]];
    then
        log_noindent " - $@"
    else
        log
    fi
}

function test_failure() {
    TEST_SUBGROUP_FAILURES='true'
    log_red "FAILURE"
    if [[ "x$@" != "x" ]];
    then
        log_noindent " - $@"
    else
        log
    fi
}

function test_details() {
    log_indent
    log "$@"
    log_unindent
}
