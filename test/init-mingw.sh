#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

cget init --std=c++14 --static -t $DIR/test/mingw.toolchain $@
