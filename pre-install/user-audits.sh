#!/bin/env bash

[[ ! -n ${SCRIPT_DIR} ]] && { echo "SCRIPT_DIR unset, exiting now"; exit 1; }
[[ ! -n ${NODES} ]] && { echo "NODES unset, exiting now"; exit 1; }

source ${SCRIPT_DIR}/tests-common.sh

function validate_root_access() {
    test_group "validate root access"
    for NODE in ${NODES[*]};
    do
        test_name "${NODE}: validating root access"
        ssh -oBatchMode=yes -l root $NODE date > /dev/null 2>&1
        if [[ $? -eq 0 ]];
        then
            test_success
        else
            test_failure
        fi

        test_name "${NODE}: validating root umask"
        OUTPUT=$(ssh -oBatchMode=yes -l root $NODE umask 2>/dev/null)
        if [[ "x${OUTPUT}" == "x" ]];
        then
            test_failure "No umask set"
        else
            test_success
            log_file "umask set to ${OUTPUT}"
        fi
    done
    test_group_complete
}

test_group "User audits"

validate_root_access

test_group_complete
