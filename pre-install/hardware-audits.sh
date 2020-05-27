#!/bin/env bash

[[ ! -n ${VBASE_DIR} ]] && { echo "VBASE_DIR unset, exiting now"; exit 1; }
[[ ! -n ${NODES} ]] && { echo "NODES unset, exiting now"; exit 1; }

source ${VBASE_DIR}/tests-common.sh

function physical_ids() {
    grep "^physical id" /proc/cpuinfo | sort | uniq | wc -l
}

function physical_core_count() {
    egrep -e "core id" -e "^physical" /proc/cpuinfo|xargs -l2 echo| awk '{ map [$4] += 1; } END { for (i in map) { print i ":" map[i] } sort }' | sort -n | awk '{ print "socket" $1 ":" $2 }'
}

function logical_core_count() {
    grep "^processor" /proc/cpuinfo | wc -l
}

function validate_two_sockets() {
    test_group "validate cpu setup"

    for NODE in ${NODES[*]};
    do
        test_name "${NODE}: validating cpu count"
        local PHYSICAL_IDS=$(typeset -f physical_ids | ssh ${NODE} "$(cat); physical_ids")
        if [[ "x${PHYSICAL_IDS}" == "x" ]];
        then
            test_failure "No physical ids detected"
        elif [[ ${PHYSICAL_IDS} -lt 2 ]];
        then
            test_failure "Physical socket count is too low: $PHYSICAL_IDS (expected >= 2)"
        else
            test_success
            log_file "phsyical ids detected: ${PHYSICAL_IDS} (minimum 2)"
        fi

        test_group "${NODE}: validating cpu core count"
        local CORE_DETAILS=$(typeset -f physical_core_count | ssh ${NODE} "$(cat); physical_core_count")
        if [[ "x${CORE_DETAILS}" == "x" ]];
        then
            test_failure "No core details detected"
        else
            for LINE in ${CORE_DETAILS};
            do
                local SOCKET=$(echo ${LINE} | cut -d : -f 1)
                local CORES=$(echo ${LINE} | cut -d : -f 2)
                test_name "${NODE}:${SOCKET}"
                if [[ ${CORES} -lt 8 ]];
                then
                    test_failure "Core count per cpu is too low: $CORES (expected >= 8)"
                else
                    test_success
                    log_file "core count per cpu detected: $CORES (minimum 8)"
                fi
            done
        fi
        test_group_complete

        test_name "${NODE}: System core count"
        log_file "Test for hyperthreaded cores across the machine"
        local CORE_COUNT=$(typeset -f logical_core_count | ssh ${NODE} "$(cat); logical_core_count")
        if [[ "x${CORE_COUNT}" == "x" ]];
        then
            test_failure "No core count detected"
        elif [[ ${CORE_COUNT} -lt 32 ]];
        then
            test_failure "System core count is too low: ${CORE_COUNT} (expected >= 32)"
        else
            test_success
            log_file "System core count detected: ${CORE_COUNT} (minimum 32)"
        fi

    done
    test_group_complete
}

test_group "Hardware audits"

validate_two_sockets

test_group_complete
