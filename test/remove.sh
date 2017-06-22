#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

VARIANTS=$(ls -1 $DIR/test/init-*.sh | sed -e 's/.*init-//g' -e 's/.sh//g')
for VARIANT in $VARIANTS; do
    export CGET_PREFIX=$DIR/build-$VARIANT
    cget rm -y $@
done
