#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
VARIANT=$1
shift
export CGET_PREFIX=$DIR/build-$VARIANT

cget rm -U -A -y
cget install -U $DIR
cget install $@
