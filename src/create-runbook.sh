#!/bin/bash

# common functions
source @BASHLIBS@/common

# setup script options
source @BASHLIBS@/shflags
DEFINE_string directory 'runbook' 'Directory in which to build the runbook' 'd'
DEFINE_string author "$(git config user.name)" 'Author of the runbook' 'a'
DEFINE_string name "$(basename $(git config remote.origin.url))" 'Name for the runbook' 'n'
DEFINE_boolean version false 'Version of the tools package' 'v'
FLAGS "$@" || log ERROR 'Failed to parse flags'
eval set -- "${FLAGS_ARGV}"

[ ${FLAGS_help} -eq ${FLAGS_TRUE} ] && exit 0
[ ${FLAGS_version} -eq ${FLAGS_TRUE} ] && 
    {
        echo "PACKAGE_VERSION"
        exit 0
    }

SPHINX=$(which sphinx-quickstart) ||
    {
        log ERROR "Could not find sphinx-quickstart. Is it installed?"
        exit 1
    }

sphinx-quickstart -q \
    --sep \
    --dot=_ \
    --project="$FLAGS_name" \
    --author="$FLAGS_author" \
    -v 0.1 \
    --release=0.1 \
    --suffix=.rst \
    --master=index\
    --ext-todo \
    --makefile \
    --no-batch \
    "$FLAGS_directory"

SIDEBAR_CONF="html_sidebars = { '**': ['globaltoc.html', 'relations.html', 'sourcelink.html', 'searchbox.html'], }"
sed -i -e "s/#html_sidebars = {}/$SIDEBAR_CONF/;s/alabaster/bizstyle/;" "$FLAGS_directory/source/conf.py" ||
    {
        log ERROR "Failed to configure sidebar"
        exit 1
    }
