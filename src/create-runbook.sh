#!/bin/bash

# common functions
source @BASHLIBS@/common

# setup script options
source @BASHLIBS@/shflags
DEFINE_string name 'MY_WALK_BOOK' 'Name for the runbook' 'n'
FLAGS "$@" || log ERROR 'Failed to parse flags'
eval set -- "${FLAGS_ARGV}"
