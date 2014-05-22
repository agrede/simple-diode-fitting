#!/usr/bin/perl -w

use warnings;
use strict;

opendir(my $dh, "./") || die "cannot open dir";
my @fs = sort(readdir($dh));
closedir($dh);

my @A1 = ("64mm 8x wide R","32mm 4x wide R","16mm 2x wide R","64mm 8x narrow B",
          "32mm 4x narrow B","16mm 2x narrow B","64mm 8x wide L",
          "32mm 4x wide L","16mm 2x wide L");
my @OT = ("64mm 8x wide R","32mm 4x wide R","64mm 8x narrow B","32mm 4x narrow B",
          "64mm 8x wide L","32mm 4x wide L","64mm 8x narrow T",
          "32mm 4x narrow T",);

my $beg = "";
my $md1 = "";
my $md2 = "";
my $end = "";

my $sf;
open($sf, "<", "./begin.tex") || die "cant open begin.tex";
$beg = join('',<$sf>);
close($sf);

open($sf, "<", "./mid1.tex") || die "cant open mid1";
$md1 = join('',<$sf>);
close($sf);

open($sf, "<", "./mid2.tex") || die "cant open mid2";
$md2 = join('',<$sf>);
close($sf);

open($sf, "<", "./end.tex") || die "cant open end";
$end = join('',<$sf>);
close($sf);

open(my $rf, ">", "./results.tex") || die "can't open results";
{
    sub readData($) {
        my ($path) = @_;
        my @r = ();
        open(FH, "<", $path) || die($!);
        while (<FH>) {
            chomp;
            @{$r[$#r+1]} = split(/,/);
        }
        close(FH);
        return @r;
    }
}
my @rows = ("Initial", "log/lin", "\\%/lin", "log/exp", "\\%/exp");
my @cols = ("%.2e","%.3g","%.3g","%.2e");

my $lastSec = "";
for my $f (@fs) {
    next unless ($f =~ /^GOF_([A-Z]\d)_(\d)\.csv$/);
    my $fp = $1 . "_" . $2;
    my $sec = $1;
    my $subsec = $sec eq "A1" ? $A1[$2-1] : $OT[$2-1];
    my @dta = readData($f);
    if ($lastSec ne $sec) {
        print $rf "\\section{" . $sec . "}";
        $lastSec = $sec;
    }
    print $rf "\n\n\\subsection{" . $subsec .
            "}\n\n\\begin{frame}\n  \\frametitle{" . $sec .
                    "}\n  \\framesubtitle{" . $subsec . "}\n";
    print $rf $beg . "\n" . "\\includegraphics[width=\\textwidth]{" . $fp
            . "}\n" . $md1 . "\n";
    my $k = 0;
    my @tbl1;
    my @tbl2;
    for my $row (@rows) {
        my @tblrow = ($row);
        for (my $i=0;$i<4;$i++) {
            push(@tblrow,sprintf($cols[$i],$dta[$i][$k]));
        }
        push(@tbl1,join(" & ", @tblrow));
        @tblrow = ($row);
        for (my $i=0;$i<3;$i++) {
            push(@tblrow,sprintf("%.2e",$dta[$i+4][$k]));
        }
        push(@tbl2,join(" & ", @tblrow));
        $k++;
    }
    print $rf join("\\\\\n", @tbl1) . "\n" . $md2 . "\n";
    print $rf join("\\\\\n", @tbl2) . "\n" . $end;
}
close($rf);
