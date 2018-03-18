#!/bin/sh

#NOTE - this is SHELL script, not perl script! .pl extension is preserved for compatibility reasons

cd "`dirname $0`"

machine=`uname -m`
perlsubdir=
perlbin=

echo $machine | grep 86 > /dev/null && { perlsubdir=linux-x86; }
echo $machine | grep 86_64 > /dev/null && { perlsubdir=linux-x86_64; }


perldir="`pwd`"/../lib/gui/perl/${perlsubdir}/
if [ -r "${perldir}" ]; then
    PATH="${perldir}"/bin:"$PATH"
    export PATH

    PERL5LIB="${perldir}"/lib/:"${perldir}"/lib/5.18.4/:"${perldir}"/../common-inc/:"$PERL5LIB"
    export PERL5LIB

    perlbin="${perldir}"/bin/perl;
else
    perlbin=`which perl`
    which perl > /dev/null || {
	echo "you do not have perl installed. Please install package 'perl' to use this software"
	exit 1;
    };
fi

cd  "../lib/gui/site/stunnixwebsrv/"  || cd "../lib/stunnix-webserver/";
exec "${perlbin}" ./startsite.pl

