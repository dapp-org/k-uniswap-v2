#!/usr/bin/env bash
set -x

if [[ $# -ne 1 ]]; then
    echo "Commit message missing"
    exit 1
fi

BASE=$(pwd)
declare -a dirs=( $BASE/deps/klab/evm-semantics/deps/k/ $BASE/deps/klab/evm-semantics $BASE/deps/klab $BASE )

for dir in "${dirs[@]}"; do
    cd $dir
    git add .
    git ci -m "$1"
    git push real
done
