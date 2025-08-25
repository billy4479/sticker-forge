#!/usr/bin/env bash

set -euxo pipefail

find "$1" -type f | exec rush -e "./make-webp.sh -v \"{}\" $2"
