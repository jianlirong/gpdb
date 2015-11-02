#!/bin/sh
# A script to set up the environment to build GPDB
# build.sh

EXTRA_DEPEND_PATH=/home/jianlirong/GPDB/ext
EXTRA_DEPEND_BIN=${EXTRA_DEPEND_PATH}/bin
EXTRA_DEPEND_INC=${EXTRA_DEPEND_PATH}/include
EXTRA_DEPEND_LIB=${EXTRA_DEPEND_PATH}/lib

export PATH=${EXTRA_DEPEND_BIN}:${PATH}
export LD_LIBRARY_PATH=${EXTRA_DEPEND_LIB}:${LD_LIBRARY_PATH}

./configure --with-openssl --with-python --enable-debug --enable-depend --with-includes=${EXTRA_DEPEND_INC} --with-libraries=${EXTRA_DEPEND_LIB} --prefix=/home/jianlirong/GPDB/devel
