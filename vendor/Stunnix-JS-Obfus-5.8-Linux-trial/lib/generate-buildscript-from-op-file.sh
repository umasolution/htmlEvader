#!/bin/sh

#this script takes name of .op file as 1st argument and dumps buildscript on stdout

[ $# -eq 1 ] || { echo usage: $0 filename.op; exit 1; }

opfile=$1 
obfustype=cxx #js for JS-Obfus, cxx for CXX-Obfus, vbs for VBS-Obfus, perl for Perl-Obfus
port=9000  #port where project manager is running on. Default port is 9000
tempprjname=XXX #name of file where project file will be stored in
tempprjpath=~/.${obfustype}-obfus-projects/${tempprjname}.op

cp -f $opfile ${tempprjpath} #install new project
wget -qO /dev/stdout http://127.0.0.1:${port}/obf-ui/ui.xpl/${tempprjname}/project.export.export.buildscript 
status=$?
rm -f ${tempprjpath} #clean after use
[ $status -eq 0 ] || { echo Failed exporting buildscript - no Project Manager running on port $port; exit 1; }

