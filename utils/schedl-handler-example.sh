#!/usr/bin/sh

## NOTE: This script creates a directory in `tmp' (which is hopefully your
## `tmpdir'), then it looks for the output of schedl and creates files and
## script in that `tmpdir', so that it can be resolved later. This is just an
## example of what you can do with schedl.

mkdir -p /tmp/schedl/ 2>/dev/null

[[ -f /tmp/schedl/session-lock ]] && exit 1

file= content= script_content= script=false
jobfiles=() # change this

for jobfile in ${jobfiles[@]}; do
  schedl $jobfile 2>/dev/null \
  | sed -n \
        -e '/^JOB:/s/JOB: //p' \
        -e '/^DO:/s/DO: /!/p'\
  | while read job; do
    [[ $job =~ ^$ ]] && continue

    if [[ $job =~ ^! ]]; then
      script=true
      script_content=$(echo $job | sed 's/^!//')
      continue
    fi

    file=/tmp/schedl/$(echo $job | cut -d' ' -f1)
    content=$(echo $job | cut -d' ' -f2-)

    echo "$content" > $file

    if $script; then
      echo "$script_content" > $file.sh
      chmod +x $file.sh
      script=false
    fi
  done
done
