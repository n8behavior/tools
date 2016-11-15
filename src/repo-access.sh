#!/bin/bash

# common functions
source @BASHLIBS@/github

# setup script options
DEFINE_string name '' 'Name for the GitHub repository' 'n'
DEFINE_string acl '' 'Name for the ACL file to process' 'f'
DEFINE_boolean list false 'List access' 'l'
DEFINE_boolean delete false 'Delete access' 'd'
DEFINE_boolean add false 'Add access' 'a'
FLAGS "$@" || log ERROR 'Failed to parse flags'
eval set -- "${FLAGS_ARGV}"
enforce_flags

# ensure we have a repo name
#[ "$FLAGS_name" ] || 
#{
#    log ERROR "You must provide a repository name"
#    exit 1
#}

# ensure we have an ACL file
[ "$FLAGS_acl" ] || 
{
    log ERROR "You must provide an ACL file"
    exit 1
}

# list access
[ "${FLAGS_list}" = "${FLAGS_TRUE}" ] && 
{
    curl -sS -u "$FLAGS_username:$FLAGS_token" \
    $API/orgs/$FLAGS_org/teams | \
    $JQ -r  '.[] | .name'
}

# remove all the current labels
[ "${FLAGS_delete}" = "${FLAGS_TRUE}" ] && 
{
    curl -sS -u "$FLAGS_username:$FLAGS_token" \
    $API/repos/$FLAGS_org/$FLAGS_name/labels | \
    $JQ -r  '.[] | .name' | \
    sed 's/ /%20/g' | \
    while read label
    do
        curl -sS -X DELETE -u "$FLAGS_username:$FLAGS_token" \
            $API/repos/$FLAGS_org/$FLAGS_name/labels/$label
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
on-hold
EOL
) | \
    while read label
    do
        data="{\"name\": \"$label\", \"color\": \"ededed\"}"
        curl -sS -u "$FLAGS_username:$FLAGS_token" \
            -d "$data" \
            $API/repos/$FLAGS_org/$FLAGS_name/labels
    done
}

