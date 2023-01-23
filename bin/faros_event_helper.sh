#!/bin/bash

# Environment Variables that need to be defined
# - FAROS_API_KEY
# - FAROS_GRAPH
# - FAROS_URL

export FAROS_GRAPH='will'
export FAROS_URL='https://dev.api.faros.ai'
export FAROS_RUN_PIPELINE="$(hostname)"
export FAROS_RUN_ORG='faros-ai'
export FAROS_RUN_SOURCE='Mock'
export FAROS_RUN_ID="$(git branch --show-current)"
export FAROS_VCS_ORG='faros-ai'
export FAROS_VCS_REPO='lighthouse'
export FAROS_VCS_SOURCE='Mock'

NOW="$(jq -n 'now * 1000 | floor')"

function parseFlags() {
    while (($#)); do
        case "$1" in
            --step) run_step="$2" && shift 2 ;;
            --commit-sha) commit_sha="$2" && shift 2 ;;
            --commit-message) commit_message="$2" && shift 2 ;;
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
            SEND_COMMIT)
                send_commit
                shift ;;
        esac
    done
}

function run_start(){
    echo "Sending run start event"
    ./bin/faros_event.sh CI \
        --run_status "Running" \
        --run_start_time "Now"
}

function run_success(){
    echo "Sending run success event"
    ./bin/faros_event.sh CI \
        --run_status "Success" \
        --run_end_time "Now"
}

function run_failed(){
    echo "Sending run failed event"
    ./bin/faros_event.sh CI \
        --run_status "Failed" \
        --run_end_time "Now"
}

function run_step_start(){
    echo "Sending run step start event"
    ./bin/faros_event.sh CI \
        --run_step_id "${run_step}  $(jq -nr 'now | todate')" \
        --run_step_name "${run_step}" \
        --run_step_status "Running" \
        --run_step_start_time "Now"
}

function run_step_success(){
    echo "Sending run step success event"
    ./bin/faros_event.sh CI \
        --run_step_id "${run_step}  $(jq -nr 'now | todate')" \
        --run_step_name "${run_step}" \
        --run_step_status "Success" \
        --run_step_end_time "Now"
}

function run_step_failed(){
    echo "Sending run failed event"
    ./bin/faros_event.sh CI \
        --run_step_id "${run_step}  $(jq -nr 'now | todate')" \
        --run_step_name "${run_step}" \
        --run_step_status "Failed" \
        --run_step_end_time "Now"
}

function send_commit(){
    echo "Sending commit information"
    ./bin/faros_event.sh CI \
        --commit "$FAROS_VCS_SOURCE://$FAROS_VCS_ORG/$FAROS_VCS_REPO/$commit_sha"

    echo "$commit_message"

    curl -X 'POST' \
      "$FAROS_URL/graphs/$FAROS_GRAPH/revisions" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -H "Authorization: $FAROS_API_KEY" \
      -d '{
        "origin": "Faros_Script_Event",
        "entries": [
          {
            "vcs_Commit": {
              "sha": "'$commit_sha'",
              "message": "'"$commit_message"'",
              "createdAt": '$NOW',
              "repository": {
                "name": "'$FAROS_VCS_REPO'",
                "organization": {
                  "uid": "'$FAROS_VCS_ORG'",
                  "source": "'$FAROS_VCS_SOURCE'"
                }
              }
            }
          }
        ]
      }' | jq
}

function main(){
    parseFlags "$@"
    set -- "${POSITIONAL[@]:-}" # Restore positional args
    processType "$@"
}

main "$@"; exit
