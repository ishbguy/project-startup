#!/usr/bin/env bash
# Copyright (c) 2018 Herbert Shen <ishbguy@hotmail.com> All Rights Reserved.
# Released under the terms of the MIT License.

# ONLY allow sourced
[[ ${BASH_SOURCE[0]} == "$0" ]] \
    && { echo "Only allow to be sourced, not for running." >&2; exit 1; }
# source guard
[[ $LIB_SOURCED -eq 1 ]] && return
declare -r LIB_SOURCED=1
declare -r LIB_ABS_SRC="$(realpath "${BASH_SOURCE[0]}")"
declare -r LIB_ABS_DIR="$(dirname "$LIB_ABS_SRC")"

lib() {
    # What to do
    true
}

# vim:set ft=sh ts=4 sw=4:
