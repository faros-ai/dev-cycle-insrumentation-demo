#!/bin/bash

# Environment Variables that need to be defined
# - FAROS_API_KEY
# - FAROS_GRAPH
# - FAROS_URL

FAROS_GRAPH='will'
FAROS_URL='https://dev.api.faros.ai'

function parseFlags() {
    while (($#)); do
        case "$1" in
            --run)      run="$2"            && shift 2 ;;
            --step)     run_step="$2"       && shift 2 ;;
            *)
                POSITIONAL+=("$1") # save it in an array for later
                shift ;;
        esac
    done
}

function processType() {
    while (($#)); do
        case "$1" in
            RUN_START)
                run_start
                shift ;;
            RUN_SUCCESS)
                run_success
                shift ;;
            RUN_FAILED)
                run_failed
                shift ;;
            RUN_STEP_START)
                run_step_start
                exit 0 ;;
            RUN_STEP_SUCCESS)
                run_step_success
                shift ;;
            RUN_STEP_FAILED)
                run_step_failed
                shift ;;
        esac
    done
}

function run_start(){
    echo "Sending run start event"
    ./faros_event.sh CI \
        --run "${run}" \
        --run_status "Running" \
        --run_start_time "Now"
}

function run_success(){
    echo "Sending run success event"
    ./faros_event.sh CI \
        --run "${run}" \
        --run_status "Success" \
        --run_end_time "Now"
}

function run_failed(){
    echo "Sending run failed event"
    ./faros_event.sh CI \
        --run "${run}" \
        --run_status "Failed" \
        --run_end_time "Now"
}

function run_step_start(){
    echo "Sending run step start event"
    ./faros_event.sh CI \
        --run "${run}" \
        --run_step "${run_step}" \
        --run_step_status "Running" \
        --run_step_start_time "Now"
}

function run_step_success(){
    echo "Sending run step success event"
    ./faros_event.sh CI \
        --run "${run}" \
        --run_step "${run_step}" \
        --run_step_status "Success" \
        --run_step_end_time "Now"
}

function run_step_failed(){
    echo "Sending run failed event"
    ./faros_event.sh CI \
        --run "${run}" \
        --run_step "${run_step}" \
        --run_step_status "Failed" \
        --run_step_end_time "Now"
}

function main(){
    parseFlags "$@"
    set -- "${POSITIONAL[@]:-}" # Restore positional args
    processType "$@"
}

main "$@"; exit
