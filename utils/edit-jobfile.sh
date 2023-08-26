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

then=$(stat -Lc '%Y' $jobfile)
then=$(date -d "@${then}" +'%Y%m%d%H%M')

$EDITOR $jobfile # this should take the foreground

touch -m -t "$then" $jobfile
