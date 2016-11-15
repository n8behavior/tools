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

# ensure sphinx-quickstart is installed
SPHINX=$(which sphinx-quickstart 2>/dev/null) || 
{
    log INFO "Could not find sphinx-quickstart."
	echo "Installing..."
    pip install -q Sphinx sphinx-autobuild || exit 1
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
    "$FLAGS_directory" ||
{
    log ERROR "Could not create runbook"
    exit 1
}

# add livehtml target to build
cat << EOM >> $FLAGS_directory/Makefile

.PHONY: livehtml
livehtml:
	sphinx-autobuild -i '*.swp' -i '*.swx' -b html \$(ALLSPHINXOPTS) \$(BUILDDIR)/html
EOM

# create a contacts page in the runbook
cat << EOM >> $FLAGS_directory/source/contacts.rst
+----------+------------+--------------+------------------+
| Name     | Title      | Phone        | Email            |
+==========+============+==============+==================+
| John Doe | Consultant | 123-456-7890 | john@example.com |
+----------+------------+--------------+------------------+
EOM
# add contacts page to index with one line of space above
sed -i '/:maxdepth:/a \ \ \ contacts' "$FLAGS_directory/source/index.rst"
sed -i '/:maxdepth:/G' "$FLAGS_directory/source/index.rst"

SIDEBAR_CONF="html_sidebars = { '**': \
    ['globaltoc.html', 'relations.html', 'sourcelink.html', 'searchbox.html'], }"
sed -i -e "s/#html_sidebars = {}/$SIDEBAR_CONF/; \
    s/alabaster/bizstyle/;" \
    "$FLAGS_directory/source/conf.py" ||
    {
        log ERROR "Failed to configure sidebar"
        exit 1
    }

# now we add a Dockerfile
cat << EOM > $FLAGS_directory/Dockerfile
FROM puterstructions/runbook:onbuild
EOM
