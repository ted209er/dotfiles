# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# shell must be interactive
case $- in
  *i*) ;;
  *) return
esac

# reset all aliases
unalias -a

# Needed to call docker running on Windows from Bash

# export PATH="$HOME/bin:$HOME/.local/bin"
# export PATH="$PATH:/mnt/c/Program Files/Docker/Docker/resources/bin"

# alias docker=docker.exe
# alias docker-compose=docker-compose.exe

export PATH=\
$PATH:\
$HOME/bin:\
$HOME/.node/bin:\
/usr/local/opt/coreutils/libexec/gnubin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/sbin:\
/usr/bin:\
/snap/bin:\
/sbin:\
/bin

alias path='echo -e ${PATH//:/\\n}' # human readable path
alias getcreds='cp /c/Users/thomas.autry/Downloads/credentials ~/.aws/'

[ -z "$OS" ] && export OS=`uname`
case "$OS" in
  Linux)           export PLATFORM=linux;;
  *indows*)        export PLATFORM=windows ;;
  *FreeBSD|Darwin) export PLATFORM=mac ;;
  *)               export PLATFORM=unknown ;;
esac

onmac () {
  [[ $PLATFORM == mac ]] && return 0
  return 1
} && export -f onmac

onwin () {
    [[ $PLATFORM == windows ]]  && return 0
      return 1
} && export -f onwin

onlinux () {
    [[ $PLATFORM == linux ]]  && return 0
      return 1
} && export -f onlinux

onunknown () {
    [[ PLATFORM == unknown ]]  && return 0
      return 1
} && export -f onunknown

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

set bell-style none
#set -o noclobber

shopt -s checkwinsize
shopt -s expand_aliases
shopt -s nullglob
shopt -s globstar
shopt -s dotglob
shopt -s extglob

# There really is no reason to *not* use the GNU utilities for your login
# shell but there are lot of reasons *to* use it. The only time it could
# present a problem is using other shell scripts written specifically for
# Mac (darwin/bsd). There are far more scripts written to use the GNU
# utilities in the world. Plus you finger muscle memory will be
# consistent
# across Linux and Mac.

if [[ $PLATFORM = mac ]]; then
  if ! havecmd gls; then
    echo 'Need to `brew install coreutils` for Mac to work.'
  fi
fi

# Graphic web site shortcuts.

declare -A sites=(
  [github]=github.com
  [gitlab]=gitlab.com
  [protonmail]=protonmail.com
  [skilstak]=skilstak.io
  [dockhub]=hub.docker.com
  [twitter]=twitter.com
  [medium]=medium.com
  [reddit]=reddit.com
  [hackerone]=hackerone.com
  [bugcrowd]=bugcrowd.com
  [synack]=synack.com
  [bls]=bls.gov
  [youtube]=youtube.com
  [vimeo]=vimeo.com
  [emojipedia]=emojipedia.com
  [netflix]=netflix.com
  [amazon]=amazon.com
)

for shortcut in "${!sites[@]}"; do
  url=${sites[$shortcut]}
  alias $shortcut="open https://$url &>/dev/null"
done

alias '?'=duck
alias '??'=google

############################# Edit Shortcuts #############################

export EDITOR=vi
export VISUAL=vi
export EDITOR_PREFIX=vi

export VIMSPELL=(~/.vim/spell/*.add)
declare personalspell=(~/.vimpersonal/spell/*.add)
[[ -n "$personalspell" ]] && VIMSPELL=$personalspell
declare privatespell=(~/.vimprivate/spell/*.add)
[[ -n $privatespell ]] && VIMSPELL=$privatespell

# Commonly edited files.

declare -A edits=(
  [bashrc]=~/.bashrc
  [personal]=~/.bash_personal
  [private]=~/.bash_private
  [profile]=~/.profile
  [spell]=$VIMSPELL
)

for cmd in "${!edits[@]}"; do
  path=${edits[$cmd]}
  case $PLATFORM in
    *) alias $EDITOR_PREFIX$cmd="$EDITOR '$path';warnln 'Make sure you git commit your changes (if needed).'" ;;
  esac
done

############################## Markdown-ish ##############################

# Minimal packrat parsing expression grammar (PEG):
#
#   Mark      <- Span* !.
#   Span      <- Plain / StrongEm / Strong / Emphasis / Link / Code
#   StrongEm  <- '***' .* '***'
#   StrongEm  <- '***' .* '***'
#   Strong    <- '**' .* '**'
#   Emphasis  <- '*' .* '*'
#   Link      <- '<' .* '>'
#   Code      <- '`' .* '`'
#   Plain     <- DQUOTE / QUOTE / LARROW / RARROW / ELLIPSIS / .*
#   DQUOTE    <- '"'
#   QUOTE     <- "'"
#   LARROW    <- " <- "
#   RARROW    <- " -> "
#   ELLIPSIS  <- '...'
#
# There's no character escape support because it isn't needed for most
# all use cases here.

export md_strongem=$red     #  ***strongem***
export md_strong=$yellow    #  **strong**
export md_emphasis=$magen   #  *emphasis*
export md_code=$cyan        #  `code`
export md_plain=''          #  plain
mark () {
  declare inemphasis instrong instrongem incode indquote inquote inlink i
  declare defsol1="$normal"
  declare defsol2="$normalbg"

  # Detect default colors (fore, bg) from optional first and
  # second arguments.

  issol "$1" && defsol1="$1" && shift
  issol "$1" && defsol2="$1" && shift
  declare defsol="$defsol1$defsol2"
  echo -n "$defsol"

  # The main content is almost always within single quotes to prevent
  # shell expansions, but we'll combine the remaining arguments anyway for
  # convenience (like echo does).

  declare buf=$*

  # recursive descent parser

  for (( i=0; i<${#buf}; i++ )); do

    # ***strongem***

    if [[ "${buf:$i:3}" = '***' ]]; then
      if [[ -z "$instrongem" ]]; then
        echo -n "$md_strongem"
        #echo -n '<strongem>'
        instrongem=1
      else
        #echo -n '</strongem>'
        echo -n $defsol
        instrongem=''
      fi
      i=$[i+2]
      continue
    fi

    # **strong**

    if [[ "${buf:$i:2}" = '**' ]]; then
      if [[ -z "$instrong" ]]; then
        echo -n "$md_strong"
        #echo -n '<strong>'
        instrong=y
      else
        #echo -n '</strong>'
        echo -n $defsol
        instrong=''
      fi
      i=$[i+1]
      continue
    fi

    # *emphasis*

    if [[ "${buf:$i:1}" = '*' ]]; then
      if [[ -z "$inemphasis" ]]; then
        echo -n "$md_emphasis"
        #echo -n '<emphasis>'
        inemphasis=y
      else
        #echo -n '</emphasis>'
        echo -n $defsol
        inemphasis=''
      fi
      continue
    fi

    # `code`

    if [[ "${buf:$i:1}" = '`' ]]; then
      if [[ -z "$incode" ]]; then
        echo -n "$md_code"
        #echo -n '<code>'
        incode=y
      else
        #echo -n '</code>'
        echo -n $defsol
        incode=''
      fi
      continue
    fi

    # "

    if [[ "${buf:$i:1}" = '"' ]]; then
      if [[ -z "$indquote" ]]; then
        echo -n '“'
        indquote=y
      else
        echo -n '”'
        indquote=''
      fi
      continue
    fi

    # '

    if [[ "${buf:$i:1}" = "'" ]]; then
      if [[ -z "$inquote" ]]; then
        echo -n '‘'
        inquote=y
      else
        echo -n '’'
        inquote=''
      fi
      continue
    fi

    # <-

    if [[ "${buf:$i:4}" = ' <- ' ]]; then
      echo -n " ← "
      i=$[i+3]
      continue
    fi

    # ->

    if [[ "${buf:$i:4}" = ' -> ' ]]; then
      echo -n " → "
      i=$[i+3]
      continue
    fi

    # ...

    if [[ "${buf:$i:3}" = '...' ]]; then
      echo -n "…"
      i=$[i+2]
      continue
    fi

    # <link>

    if [[ "${buf:$i:1}" = '<' ]]; then
      if [[ -z "$inlink" ]]; then
        echo -n $md_code${buf:$i:1}
        #echo -n '<link>'
        inlink=y
      fi
      continue
    fi
    if [[ "${buf:$i:1}" = '>' ]]; then
      if [[ -n "$inlink" ]]; then
        #echo -n '</link>'
        echo -n ${buf:$i:1}$defsol
        inlink=''
      fi
      continue
    fi

    echo -n "${buf:$i:1}"
  done
  echo -n $reset
} && export -f mark


havecmd () {
  type "$1" &>/dev/null
  return $?
} && export -f havecmd

open () {
  case $PLATFORM in
    mac) open $* ;;
    windows) telln 'Not yet supported.';;
    linux) xdg-open $*;;
  esac
} && export -f open

confirm () {
  declare yn
  read -p " [y/N] " yn
  [[ ${yn,,} =~ y(es)? ]] && return 0
  return 1
} && export -f confirm

tell () {
  declare buf=$(argsorin "$*")
  mark $md_plain "$buf"
} && export -f tell

telln () {
  tell "$*"; echo
} && export -f telln

remind () {
  declare buf=$(argsorin "$*")
  tell "*REMEMBER:* $buf"
} && export -f remind

remindln () {
  remind "$*"; echo
} && export -f remindln

danger () {
  declare buf=$(argsorin "$*")
  tell "${blinkon}***DANGER:***${blinkoff} $buf"
} && export -f danger

dangerln () {
  danger "$*"; echo
} && export -f dangerln

warn () {
  declare buf=$(argsorin "$*")
  tell "${yellow}WARNING:${reset} $buf"
} && export -f warn

warnln () {
  warn "$*"; echo
} && export -f warnln

usageln () {
  declare cmd="$1"; shift
  declare buf="$*"
  tell "**usage:** *$cmd* $buf"
  echo
} && export -f usageln

# When we must.

lower () {
  echo ${1,,}
} && export -f lower

upper () {
  echo ${1^^}
} && export -f upper

tstamp () {
  echo -n $1
  date '+%Y%m%d%H%M%S'
} && export -f tstamp

tstampfile () {
  declare path="$1"
  declare pre=${path%.*}
  declare suf=${path##*.}
  echo -n $pre.$(tstamp)
  [[  "$pre" != "$suf" ]] && echo .$suf
} && export -f tstampfile

now () {
  echo "$1" $(date "+%A, %B %e, %Y, %1:%M:%S%p")
} && export -f now

now-s () {
  echo "$1" $(date "+%A, %B %e, %Y, %l:%M %p")
} && export -f now-s

epoch () {
  date +%s
} && export -f epoch

weekday () {
  echo $(lower $(date +"%A"))
} && export -f weekday

month () {
  echo $(lower $(date +"%B"))
} && export -f month

year () {
  echo $(lower $(date +"%Y"))
} && export -f year

week () {
  date +%W
} && export -f week

newest () {
  IFS=$'\n'
  f=($(ls -1 --color=never -trd ${1:-.}/*))
  echo "${f[-1]}"
} && export -f newest

listening () {
  case "$PLATFORM" in
    mac)                                 # TODO rewrite with perg
      netstat -an -ptcp | grep LISTEN
      lsof -i -P | grep -i "listen"
      ;;
    *) netstat -tulpn |grep LISTEN ;;
  esac
} && export -f listening

sshspeedtest () {
  yes | pv |ssh "$1" "cat >/dev/null"
} && export -f sshspeedtest

if havecmd dircolors; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

alias lsplain='ls -h --color=never'
alias ls='ls -h --color=auto'
alias lx='ls -AlXB'    #  Sort by extension.
alias lxr='ls -ARlXB'  #  Sort by extension.
alias lk='ls -AlSr'    #  Sort by size, biggest last.
alias lkr='ls -ARlSr'  #  Sort by size, biggest last.
alias lt='ls -Altr'    #  Sort by date, most recent last.
alias ltr='ls -ARltr'  #  Sort by date, most recent last.
alias lc='ls -Altcr'   #  Sort by change time, most recent last.
alias lcr='ls -ARltcr' #  Sort by change time, most recent last.
alias lu='ls -Altur'   #  Sort by access time, most recent last.
alias lur='ls -ARltur' #  Sort by access time, most recent last.
alias ll='ls -Alhv'    #  A better long listing.
alias llr='ls -ARlhv'  #  Recursive long listing.
alias lr='ll -AR'      #  Recursive simple ls.
alias lm='ls |more'    #  Pipe through 'more'
alias lmr='lr |more'   #  Pipe through 'more'

################################## Curl ##################################

alias ipinfo="curl ipinfo.io"
alias weather="curl wttr.in"

# Igor Chubin is a god.

cheat() {
  where="$1"; shift
  IFS=+ curl "http://cht.sh/$where/ $*"
} && export -f cheat
