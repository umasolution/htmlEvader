#!/usr/bin/env perl

=pod

=head1 NAME

copy-stunnix-project-manager-mode-props.pl - copy settings of some mode in Project Manager project file, 
from one project file (with .op extension) to another one.

=head1 SYNOPSIS

B<copy-stunnix-project-manager-mode-props.pl>  I<source-file> I<destination-file> S<[ mode-id ]>

=head1 DESCRIPTION

Use this script to copy settings of some mode in Project Manager project file, from one project file (with .op 
extension) to another one.

By default, settings for mode named 'standard: treat as rawcode' are copied. If you need to copy settings of other 
mode, pass the ID of that mode as a 3rd argument to this script. To find ID of the mode, go to Settings, Edit modes,
copy the link to that mode to clipboard, paste to some text editor, strip everything before last dot, and you 
will get its mode-id, e.g. for http://127.0.0.1:9000/obf-ui-cxxo/ui.xpl/1/modes.edit._rawcode mode id is '_rawcode'.

=cut 

use strict;
use Data::Dumper;

package obfui::project;
package obfui::mode;
package main;

if (!@ARGV)
{
    print <<"EOF"
Usage: $0 source-file destination-file [mode-id]

Copies settings of [mode-id] (default: '_rawcode') from source-file to destination-file 
(where source-file and destination-file are Stunnix Obfuscator Project Manager files).

See first line of this script for more info on how to find mode-id.

EOF
;
    exit(1);
}

my $modename = @ARGV == 3 ? pop @ARGV : '_rawcode';
my @props;
my @filenames = @ARGV;
foreach my $fn (@filenames)
{
    die("can't read $fn: $@") if !-r $fn;
    our $VAR1;
    do $fn;
    die("error reading $fn:  $@, $!") if $@ || $!;
    push @props, $VAR1;
    die("no mode with id $modename defined in $fn") if !exists($VAR1->{modes}->{$modename});
}

my($srcprops,$destprops) = @props;
$destprops->{modes}->{$modename} = $srcprops->{modes}->{$modename};
open(F,">$filenames[1]") || die("can't open $filenames[1] for writing");
$Data::Dumper::Sortkeys = 1;
print F Dumper($props[1]);
close F;
