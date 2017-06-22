#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
VARIANT=$1
export CGET_PREFIX=$DIR/build-$VARIANT

RECIPES=$(find recipes | grep package.txt | cut -c9- | sed 's,/package.txt,,')
rm -f failed-$VARIANT
cget install -U $DIR
for RECIPE in $RECIPES; do
    cget rm -U -A -y
    cget install $DIR
    cget install $RECIPE
    if [ $? -ne 0 ]
    then
        echo "$RECIPE" >> failed-$VARIANT
    fi
done

