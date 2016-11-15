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

# finally create a repo on the githubs
echo -n "Creating Github repository '$FLAGS_name' ..."
curl -u "$FLAGS_username:$FLAGS_token" https://api.github.com/orgs/$FLAGS_org/repos -d '{"name":"'$FLAGS_name'"}' > /dev/null 2>&1
echo " done."

###########################################################
# This last session creates all the content and pushes it #
###########################################################

# work in a temporary directory
cd $(mktemp -d)

#Create our README
cat << EOM > README.md
$FLAGS_name
===========
Blah...
EOM

# add let's add a runbook
@BINARIES@/create-runbook --name $FLAGS_name

# Now let's push all this to our new repo
git init
git add .
git commit -m "Created by puterstructions/tools/create-repo"
git remote add origin git@github.com:$FLAGS_org/$FLAGS_name
git push -u origin master
