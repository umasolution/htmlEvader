#!/usr/bin/perl

use strict;
use Win32::Shortcut;
use FindBin;
use POSIX;

my %cfg;
{
    chdir $FindBin::Bin;
    %cfg = @ARGV;
    if (!($cfg{prodtitle} && $cfg{sitesec}))
    {
	%cfg = qw(prodtitle JS-Obfus sitesec jo) if (-d '../../js-obfus');
	%cfg = qw(prodtitle Perl-Obfus sitesec po) if (-d '../../perl-obfus');
	%cfg = qw(prodtitle VBS-Obfus sitesec vbso) if (-d '../../vbs-obfus');
	%cfg = qw(prodtitle CXX-Obfus sitesec cxxo) if (-d '../../cxx-obfus');
    }
}

sub get_shell_path
{
    eval("use Win32::Registry;");
    if (!$@)
    {
	my $prefix = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders\\";
	my $item = "Programs";
	my $k;
	$::HKEY_CURRENT_USER->Open($prefix,$k);
	my ($type,$value);
        $k->QueryValueEx($item,$type,$value);
	return $value;
    } else {
	die("Win32::Registry is missing; invalid configuration of perl encountered.");
    }
}


my $outp = get_shell_path() . "\\Stunnix $cfg{prodtitle}";
my $srvpath = "$FindBin::Bin\\..\\..\\stunnix-webserver\\";
sub register_shortcut
{
    my ($title,$url) = @_;
    my $l =new Win32::Shortcut();
    $l->{WorkingDirectory} = $srvpath;
    $l->{Path} = "wperl";
    $l->{Arguments} = " startsite.pl urlpath $url";
    $l->Save("$outp\\$title.lnk");
}

mkdir $outp;
register_shortcut("Stunnix $cfg{prodtitle} Project Manager","/");
register_shortcut("Browse Stunnix $cfg{prodtitle} documentation","/support/doc/$cfg{sitesec}/");
