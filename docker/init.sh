#!/bin/bash

# ensure we have a home
[ "$DOTFILES" ] && cd "$DOTFILES" ||  
{
    echo log ERROR "You must set DOTFILES to a valid directory.  Recommend setting it to HOME."
    exit 1
}

SOURCEDIR=$(readlink -f "$DOTFILES"/'.noinstall')
echo "SOURCEDIR=$SOURCEDIR"
mkdir -p $SOURCEDIR && cd $SOURCEDIR || 
{
    echo log ERROR "Failed entering DOTFILES [$DOTFILES]"
    exit 1
}

cat << EOM > $SOURCEDIR/puterstructions-tools
alias create-repo='docker run --rm puterstructions-tools /usr/local/bin/create-repo'
EOM
