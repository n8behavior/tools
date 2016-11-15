#!/bin/bash

# common functions
source @BASHLIBS@/github

# setup script options
DEFINE_string name '' 'Name for the GitHub repository' 'n'
DEFINE_boolean privaterepo true 'The github repo should be private' 'p'
FLAGS "$@" || log ERROR 'Failed to parse flags'
eval set -- "${FLAGS_ARGV}"
enforce_flags

# ensure we have a repo name
[ "$FLAGS_name" ] || 
{
    log ERROR "You must provide a repository name"
    exit 1
}

PRIVATE_REPO='false'
if [ "${FLAGS_privaterepo}" = "${FLAGS_TRUE}" ]; then
PRIVATE_REPO='true'
fi

# create a repo on the githubs
echo -n "Creating Github repository '$FLAGS_name' ..."
curl -u "$FLAGS_username:$FLAGS_token" $API/orgs/$FLAGS_org/repos -d '{"name":"'$FLAGS_name'","private":'${PRIVATE_REPO}'}' > /dev/null 2>&1
echo " done."

#PUT /teams/:id/repos/:org/:repo
echo -n "Granting access to DevOps team"
DEVOPS_ID='1783409'
curl -X PUT -u "$FLAGS_username:$FLAGS_token" $API/teams/1783409/repos/puterstructions/$FLAGS_name > /dev/null 2>&1

###########################################################
# This last section creates all the content and pushes it #
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
