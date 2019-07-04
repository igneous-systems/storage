#!/bin/bash -ex

# the containers/storage makefile presumes that your repo clone lives
# inside your gopath.
# Iggybot does not check out packages in this way, so we this script takes
# care of setting up the local environment by creating a gopath structure
# within the buildbot checkout directory, symlinking the repo root directory
# into that gopath, and 'cd'ing into the symlink path before running make.

if [ "$1" == "clean" ]; then
    set +x
    rm -rf ./go
    make clean
    exit $?
fi

mkdir -p go/src/github.com/containers/
if [ ! -e go/src/github.com/containers/storage ]; then
    ln -s $(pwd) go/src/github.com/containers/storage
fi

export PATH=$PATH:/usr/src/go1.10.3/go/bin:$(pwd)/go/bin
export GOPATH=$(pwd)/go
cd go/src/github.com/containers/storage

TAGS="btrfs_noversion" annotate-output make $@