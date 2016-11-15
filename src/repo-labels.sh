#!/bin/bash

# common functions
source @BASHLIBS@/common
TOKEN_VAR='puterstructions.tools.token'

# setup script options
source @BASHLIBS@/shflags
DEFINE_string name '' 'Name for the GitHub repository' 'n'
DEFINE_string org 'puterstructions' 'Organization for the GitHub repository' 'o'
DEFINE_string username "$(git config user.name)" 'GitHub user for authentication' 'u'
DEFINE_string token "$(git config $TOKEN_VAR)" 'GitHub token for authentication' 't'
DEFINE_boolean list false 'List all existing labels' 'l'
DEFINE_boolean delete false 'Delete all existing labels' 'd'
DEFINE_boolean add false 'Add standard labels' 'a'
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
SPHINX=$(which jq) || 
{
    log ERROR "Could not find jq. Is it installed?"
    exit 1
}

# ensure we have a repo name
[ "$FLAGS_name" ] || 
{
    log ERROR "You must provide a repository name"
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

# list lables
[ "${FLAGS_list}" = "${FLAGS_TRUE}" ] && 
{
    curl -sS -u "$FLAGS_username:$FLAGS_token" \
    https://api.github.com/repos/$FLAGS_org/$FLAGS_name/labels | \
    jq -r  '.[] | .name'
}

# remove all the current labels
[ "${FLAGS_delete}" = "${FLAGS_TRUE}" ] && 
{
    curl -sS -u "$FLAGS_username:$FLAGS_token" \
    https://api.github.com/repos/$FLAGS_org/$FLAGS_name/labels | \
    jq -r  '.[] | .name' | \
    sed 's/ /%20/g' | \
    while read label
    do
        curl -sS -X DELETE -u "$FLAGS_username:$FLAGS_token" \
            https://api.github.com/repos/$FLAGS_org/$FLAGS_name/labels/$label
    done 
}

# add the new labels
[ "${FLAGS_add}" = "${FLAGS_TRUE}" ] && 
{
(
cat << EOL
billable
non billable
ready
in progress
active
EOL
) | \
    while read label
    do
        data="{\"name\": \"$label\", \"color\": \"ededed\"}"
        curl -sS -u "$FLAGS_username:$FLAGS_token" \
            -d "$data" \
            https://api.github.com/repos/$FLAGS_org/$FLAGS_name/labels
    done
}

