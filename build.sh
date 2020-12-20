#!/bin/bash

timestamp() {
    date +"%T" # current time
}

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SOURCEDIR=$BASEDIR
BUILDDIR=$BASEDIR/build

BUILDCONF=Release
CMAKEGEN=Ninja

while getopts cit:g: flag
do
    case "${flag}" in
        c) CLEAN_BUILD="yes";;
        i) INSTALL="yes";;
        t) BUILDCONF=${OPTARG};;
        g) CMAKEGEN=${OPTARG};;
    esac
done

if [[ ! -d $BUILDDIR ]]; then
    mkdir -p $BUILDDIR
fi

cd $BUILDDIR

echo GENERATE: $CMAKEGEN -- $(timestamp)
cmake -G "$CMAKEGEN" $SOURCEDIR

if [[ $CLEAN_BUILD == "yes" ]];then
    echo CLEAN -- $(timestamp)
    cmake --build $BUILDDIR --config $BUILDCONF --target clean
fi

echo BUILD -- $(timestamp)
cmake --build $BUILDDIR --config $BUILDCONF

if [[ $INSTALL == "yes" ]]; then
    echo INSTALL -- $(timestamp)
    sudo cmake --build $BUILDDIR --config $BUILDCONF --target install
fi

echo FINISHED -- $(timestamp)
