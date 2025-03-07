#!/bin/sh

MTIME=''

case $1 in
  '--help'|'-h')
    echo "Usage:       $0 TIME FILES..."
    echo "Description: Set the mtime value (TIME) of FILES"
    exit 0;;
  *)
    MTIME=$1;;
esac

FILES=${@:2}

if [[ -z $MTIME || -z $FILES ]]; then
  echo "[ !! ] Malformed command line. See \`--help'"
  exit 1
fi

touch -m -t $MTIME $FILES
