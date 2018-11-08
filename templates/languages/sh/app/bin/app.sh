#!/usr/bin/env bash
# Copyright (c) 2018 Herbert Shen <ishbguy@hotmail.com> All Rights Reserved.
# Released under the terms of the MIT License.

# source guard
[[ $APP_SOURCED -eq 1 ]] && return
declare -r APP_SOURCED=1
declare -r APP_ABS_SRC="$(realpath "${BASH_SOURCE[0]}")"
declare -r APP_ABS_DIR="$(dirname "$APP_ABS_SRC")"

# utilities
EXIT_CODE=0
warn() { echo -e "$@" >&2; ((++EXIT_CODE)); return ${WERROR:-1}; }
die() { echo -e "$@" >&2; exit $((++EXIT_CODE)); }
usage() { echo -e "$HELP"; }
version() { echo -e "$PRONAME $VERSION"; }
defined() { declare -p "$1" &>/dev/null; }
definedf() { declare -f "$1" &>/dev/null; }
is_sourced() { [[ -n ${FUNCNAME[1]} && ${FUNCNAME[1]} != "main" ]]; }
is_array() { local -a def=($(declare -p "$1" 2>/dev/null)); [[ ${def[1]} =~ a ]]; }
is_map() { local -a def=($(declare -p "$1" 2>/dev/null)); [[ ${def[1]} =~ A ]]; }
has_tool() { hash "$1" &>/dev/null; }
ensure() {
    local cmd="$1"; shift
    local -a info=($(caller 0))
    (eval "$cmd" &>/dev/null) || die "${info[2]}:${info[0]}:${info[1]}:" \
        "${FUNCNAME[0]} '$cmd' failed." "$@"
}
date_cmp() { echo "$(($(date -d "$1" +%s) - $(date -d "$2" +%s)))"; }
pargs() {
    ensure "[[ $# -ge 3 ]]" "Need OPTIONS, ARGUMENTS and OPTSTRING"
    ensure "[[ -n $1 && -n $2 && -n $3 ]]" "Args should not be empty."
    ensure "is_map $1 && is_map $2" "OPTIONS and ARGUMENTS should be map."

    local -n __opt="$1"
    local -n __arg="$2"
    local optstr="$3"
    shift 3

    OPTIND=1
    while getopts "$optstr" opt; do
        [[ $opt == ":" || $opt == "?" ]] && die "$HELP"
        __opt[$opt]=1
        __arg[$opt]="$OPTARG"
    done
    shift $((OPTIND - 1))
}
chkobj() {
    ensure "[[ $# -gt 2 ]]" "Not enough args."
    ensure "definedf $1" "$1 should be a defined func."

    local -a miss
    local cmd="$1"
    local msg="$2"
    shift 2
    for obj in "$@"; do
        "$cmd" "$obj" || miss+=("$obj")
    done
    [[ ${#miss[@]} -eq 0 ]] || die "$msg: ${miss[*]}."
}
chkvar() { chkobj defined "You need to define vars" "$@"; }
chkfunc() { chkobj definedf "You need to define funcs" "$@"; }
chktool() { chkobj has_tool "You need to install tools" "$@"; }

# app
app() {
    local PRONAME="$(basename "${BASH_SOURCE[0]}")"
    local VERSION="v0.0.1"
    local HELP=$(cat <<EOF
$PRONAME $VERSION
$PRONAME [-hv] args
    
    -h  print this help message 
    -v  print version number

This program is released under the terms of MIT License.
EOF
)
    local -A opts args
    pargs opts args 'hv' "$@"
    shift $((OPTIND - 1))
    [[ ${opts[h]} ]] && usage && return 0
    [[ ${opts[v]} ]] && version && return 0

    # what to do

    return $EXIT_CODE
}

is_sourced || app "$@"

# vim:set ft=sh ts=4 sw=4:
