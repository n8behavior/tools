#!/bin/bash

# setup script options
source @BASHLIBS@/shflags
DEFINE_string name 'MY_WALK_BOOK' 'Name for the runbook' 'n'
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"
