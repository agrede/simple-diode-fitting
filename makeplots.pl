#!/usr/bin/perl -w

# Make plots
# Takes csv outputs from Octave and uses pdflatex with pgfplots to create plot
#
# Copyright (C) 2014 Alex J. Grede
# GPL v3, See LICENSE.txt for details
# This function is part of <NAME> (https://github.com/agrede/<GITHUB>)

use warnings;
use strict;
use File::Copy;

opendir(my $dh, "./") || die "cannot open dir";
my @fs = sort(readdir($dh));
closedir($dh);

for my $f (@fs) {
    next unless ($f =~ /^([A-Z]\d_\d)\.csv$/);
    my $fp = $1;
    copy($f, "./plot.csv");
    if ($fp =~ /^A1/) {
        `pdflatex plotA1`;
        copy("./plotA1.pdf", "./" . $fp . ".pdf");
    } else {
        `pdflatex plot`;
        copy("./plot.pdf", "./" . $fp . ".pdf");
    }
    # die();
}
