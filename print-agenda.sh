#!/usr/bin/env bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

emacsclient -e "$(cat $DIR/print-agenda.el)"
cat ~/.agenda
