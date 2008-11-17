#!/bin/sh
# quick wrapper to run local sandbox with local libsandbox
dir=${0%/*}
export LD_LIBRARY_PATH=${dir}/../libsandbox/.libs:${abs_top_builddir}/libsandbox/.libs
if [ -x "${dir}"/sandbox ] ; then
	exec "${dir}"/sandbox "$@"
else
	exec sandbox "$@"
fi