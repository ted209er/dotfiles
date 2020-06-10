#!/bin/bash
ageof () {
  declare path="$1"
  if [[ -z "$path" ]]; then
    usageln 'ageof <path>'
    return 1
  fi
  echo $(( $(date %s) - $(date -r "$path" +%s) ))
}
ageof $*
