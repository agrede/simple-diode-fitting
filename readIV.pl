#!/usr/bin/perl -w

# Parses an XLS file for IV data and creates JSON file for use in Octave
#
# Copyright (C) 2014 Alex J. Grede
# GPL v3, See LICENSE.txt for details
# This function is part of Simple Diode Fitting (https://github.com/agrede/simple-diode-fitting)

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
        if (($col_max - $col_min) < 3 || ($row_max-$row_min) < 3) { next; }

        my $col_start = -1;
        my $col_end = -1;

        my $tmpc = -1;

        while ($col_start < 0 || $col_end < 0) {
            $tmpc++;

            if ($tmpc > $col_max) {
                if ($col_start > -1) {
                    $col_end = $col_max;
                    next;
                } else {
                    die;
                }
            }

            if ($col_start > -1 &&
                (!($ws->get_cell(1,$tmpc))
                 || $ws->get_cell(1,$tmpc)->unformatted() =~ /^\s*$/)) {
                $col_end = $tmpc-1;
            }
            next unless $ws->get_cell(1, $tmpc);
            if ($ws->get_cell(1,$tmpc)->unformatted() =~ /V\s\(V\)/i
                    && $col_start < 0) {
                $col_start = $tmpc;
            }
        }
        # print join(", ", ($key, $col_start, $col_end, $row_min, $row_max)) . "\n";
        # next;

        $data->{$key}->{"V"} = ();
        $data->{$key}->{"I"} = ();

        my $kr = 0;

        for my $row (($row_min+2) .. $row_max) {
            next unless $ws->get_cell($row, $col_min);
            next unless $ws->get_cell($row, $col_min)->unformatted() ne "";
            my $kc = 0;
            my $V = $ws->get_cell($row, $col_start)->unformatted() + 0;
            $data->{$key}->{"V"}[$kr] = $V;
            for my $col (($col_start + 1) .. ($col_end)) {
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
