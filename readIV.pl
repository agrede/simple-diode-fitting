#!/usr/bin/perl -w

#
# Copyright (C) 2014 Alex J. Grede
# GPL v3, See LICENSE.txt for details
# This function is part of SAMIS (https://github.com/agrede/SAMIS)

use warnings;
use strict;
use Spreadsheet::ParseExcel;
use JSON;
use POSIX;
use Data::Dumper;

# Open File -----------------------------------------------------------
my $f = $ARGV[0];
my $parser = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($f);

# Read Data
if (!defined $workbook) {die $parser->error() . "\n"};

my $data = {};

for my $ws ( $workbook->worksheets() ) {
    if ($ws->get_name() =~ /^([A-Z]\d)$/) {
        my $key = $1;
        my ($col_min, $col_max) = $ws->col_range();
        my ($row_min, $row_max) = $ws->row_range();
        if (($col_max - $col_min) < 9 || ($row_max-$row_min) < 3) { next; }

        $data->{$key}->{"V"} = ();
        $data->{$key}->{"I"} = ();

        my $kr = 0;

        for my $row (($row_min+2) .. $row_max) {
            next unless $ws->get_cell($row, $col_min);
            next unless $ws->get_cell($row, $col_min)->unformatted() ne "";
            my $kc = 0;
            my $V = $ws->get_cell($row, $col_min)->unformatted() + 0;
            $data->{$key}->{"V"}[$kr] = $V;
            for my $col (($col_min + 1) .. ($col_min + 8)) {
                my $I = $ws->get_cell($row, $col)->unformatted() + 0;
                $data->{$key}->{"I"}[$kr][$kc] = $I;
                $kc++;
            }
            $kr++;
        }
    }
}

#print Dumper($data);
print encode_json($data);
