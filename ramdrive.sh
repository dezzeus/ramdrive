#!/usr/bin/env bash

display_help() {
    echo ""
    echo "$(basename "$0") -- a RAM drive creation utility for macOS"
    echo ""
    echo "Usage:"
    echo "  $(basename "$0") <size> [<name>]"
    echo "    - <size> is in MiB."
    echo "    - <name> allows spaces; default is 'RAM drive'."
}

[[ $# -gt 0 ]] || { display_help; exit -1; }
[[ $1 == *help || $1 == "-h" ]] && { display_help; exit; }
[[ $1 =~ ^[0-9]+$ ]] || { display_help; exit -1; }

VOLUME_SIZE=$1
VOLUME_NAME="${@:2}"
VOLUME_NAME="${VOLUME_NAME:-RAM drive}"
# The RAM amount is specified in number of sectors, each one of 512 bytes.
NUM_SECTORS=$(($VOLUME_SIZE * 2048)) # 2048 := 1024 * 1024 / 512
RAMDISK_DEVICE=$(hdiutil attach -nomount ram://$NUM_SECTORS)
[[ $? ]] || { echo "RAM reservation failed." >&2; exit -1; }
diskutil apfs create $RAMDISK_DEVICE "$VOLUME_NAME" 1> /dev/null
