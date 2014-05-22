#!/usr/bin/perl -w

# Create XLS output from fit data from csv files created in Octave
# (tailored to project)
#
# Copyright (C) 2014 Alex J. Grede
# GPL v3, See LICENSE.txt for details
# This function is part of Simple Diode Fitting (https://github.com/agrede/simple-diode-fitting)

use warnings;
use strict;
use Spreadsheet::WriteExcel;

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

my @A1 = ("64mm 8x wide R","32mm 4x wide R","16mm 2x wide R","64mm 8x narrow B",
          "32mm 4x narrow B","16mm 2x narrow B","64mm 8x wide L",
          "32mm 4x wide L","16mm 2x wide L");
my @OT = ("64mm 8x wide R","32mm 4x wide R","64mm 8x narrow B",
          "32mm 4x narrow B","64mm 8x wide L","32mm 4x wide L",
          "64mm 8x narrow T","32mm 4x narrow T");

my @clhds1 = ("I", "Initial", "log/lin", "%/lin", "log/exp", "%/exp");
my @clhds2 = ("I0","n","Rs","Rsh","r (V<0)","r (V>0)", "r (V!=0)");
my @rwhds2 = @clhds1;
shift @rwhds2;


opendir(my $dh, "./") || die "cannot open dir";
my @fs = sort(readdir($dh));
closedir($dh);

open(my $resf, ">", "./data.xls") || die "could not open writefile";

my $wb = Spreadsheet::WriteExcel->new($resf);
my $format = $wb->add_format(valign=> 'vcenter', align=>'center');
for my $f (@fs) {
    next unless ($f =~ /^([A-Z]\d)_raw\.csv$/);
    my $wsn = $1;
    my @rwhds = $wsn eq "A1" ? @A1 : @OT;
    my $ws = $wb->add_worksheet($wsn);
    my $j = 1;
    my @dta = readData($f);
    $ws->write(2,0,\@dta);
    $ws->write(1,0,"V");

    for my $rwhd (@rwhds) {
        # $ws->write(0,$j,$rwhd);
        $ws->merge_range(0,$j,0,$j+$#clhds1,$rwhd,$format);
        $ws->write_row(1,$j,\@clhds1);
        $j += $#clhds1+1;
    }
    $j += 2;
    $ws->write(1,$j+2,\@clhds2);
    @dta = readData($wsn . "_gof.csv");
    $ws->write(2,$j+2,\@dta);
    my $i = 2;
    for my $rwhd (@rwhds) {
        #$ws->write($i,$j,$rwhd);
        $ws->merge_range($i,$j,$i+$#rwhds2,$j,$rwhd,$format);
        $ws->write_col($i,$j+1,\@rwhds2);
        $i += $#rwhds2+1;
    }
}

$wb->close();
