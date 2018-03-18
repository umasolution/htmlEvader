#!/usr/bin/perl

#wrapper code start.

use strict;
use FindBin qw($Bin $Script);

my ($interp,$script);
{
    my $mapfn = "$Bin/.stunnix-script-map/$Script";
    open(FI,"<" . $mapfn) || die("can't open mapfile $mapfn: $!");
    my (@lines) = <FI>;
    close FI;

    ($interp,$script) = map { $_ =~ s,[\r\n]*,,g; $_; } @lines; #assign removing trailing newlines
}

#print "argv is " . join(',',@ARGV) . " count is " . (@ARGV+0) . "\n";
#print "interp=$interp script=$script\n";

exec($interp,$script, @ARGV);
