#!/bin/sh

jobfile=''

case $1 in
  '--help'|'-h')
    echo "Usage:       $0 JOBFILE [EDITOR]"
    echo "Description: Edit the JOBFILE without messing up \`mtime'"
    exit 0;;
  *)
    jobfile=$1;;
esac

EDITOR=${2:-$EDITOR}

then=$(stat -Lc '%y' $jobfile)

$EDITOR $jobfile # this should take the foreground

touch -d "$then" $jobfile
