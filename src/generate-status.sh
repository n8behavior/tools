#!/bin/bash

# common functions
source @BASHLIBS@/github

# setup script options
FLAGS "$@" || log ERROR 'Failed to parse flags'
eval set -- "${FLAGS_ARGV}"
enforce_flags

issue-titles() {
$JQ -r '.[] | select(.payload | has("issue")).payload.issue |
            [.created_at, .title] |
            join("\t")'
}
# list user event?s
            #"$API/users/$FLAGS_username/events" | \
curl -sS -u "$FLAGS_username:$FLAGS_token" \
            $API/repos/$FLAGS_org/tools/issues/events | \
            issue-titles
curl -sS -u "$FLAGS_username:$FLAGS_token" \
            "$API/users/$FLAGS_username/events?page=2" | \
            issue-titles

