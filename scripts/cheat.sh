#!/bin/sh

cheat() {
  where="$1"
  if [ $# -ge 1 ]; then
    shift
  fi
  IFS=+ curl "http://cht.sh/$where/ $*"
}

cheat $*
