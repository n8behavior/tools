#!/bin/bash

# common functions
source @BASHLIBS@/common
TOKEN_VAR='puterstructions.tools.token'
API='https://api.github.com'

# setup script options
source @BASHLIBS@/shflags
DEFINE_string org 'puterstructions' 'Organization for the GitHub repository' 'o'
DEFINE_string username "$(git config user.name)" 'GitHub user for authentication' 'u'
DEFINE_string token "$(git config $TOKEN_VAR)" 'GitHub token for authentication' 't'
DEFINE_boolean version false 'Version of the tools package' 'v'
FLAGS "$@" || log ERROR 'Failed to parse flags'
eval set -- "${FLAGS_ARGV}"

# exit if we have displayed help text
[ "${FLAGS_help}" = "${FLAGS_TRUE}" ] && exit 0

# exist after showing the version
[ "${FLAGS_version}" = "${FLAGS_TRUE}" ] && 
{
    echo "PACKAGE_VERSION"
    exit 0
}

# ensure jq is installed
JQ=$(which jq) || 
{
    log ERROR "Could not find jq. Is it installed?"
    exit 1
}

# ensure we have github user
[ "$FLAGS_username" ] || 
{
    log ERROR "Could not find username.\nRun 'git config --global github.user <username>'"
    exit 1
}

# ensure we have a token
[ "$FLAGS_token" ] || 
{
    log ERROR "Could not find token.\nRun 'git config --global $TOKEN_VAR <token>'"
    exit 1
}

            #.payload.commits[].message, 
            #.payload.comment.message'
issue-titles() {
$JQ '.[] |  .payload.issue.title 
            '
# date --date=$date-0000 +%d
}

# list repos
curl -sS -u "$FLAGS_username:$FLAGS_token" \
    $API/users/$FLAGS_username/events | \
        issue-titles

