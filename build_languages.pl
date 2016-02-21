#!/usr/bin/env perl
use strict;
use warnings;

use JSON::XS qw/decode_json/;
use Data::Dumper;

open( my $fh, '<', 'gherkin-languages.json' ) ||
    die "Can't open [gherkin-languages.json]";
my $input = join '', (<$fh>);
close $fh;

my $output = Data::Dumper->Dump([decode_json $input], ['$data']);

my $template = join '', (<DATA>);
$template =~ s/DATA/$output/;

print $template;

__DATA__
package Gherkin::Generated::Languages;
use utf8;
our $data = DATA;
1;
