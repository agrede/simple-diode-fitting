#!/usr/bin/perl -w

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
