#!perl

use strict;
use warnings;

use Test::More;
use Test::Differences;

my @good_files = glob("acceptance/testdata/good/*.feature");

for my $file ( @good_files ) {
    for my $type (qw/tokens ast pickles/) {
        my $result = `bin/gherkin-generate-$type $file`;
        my $expected = `cat $file.$type*`;
        $expected =~ s!../testdata/!acceptance/testdata/!g;
        eq_or_diff( $result, $expected, "$file - $type");
    }
}

my @bad_files = glob("acceptance/testdata/bad/*.feature");

for my $file ( @bad_files ) {
    my $result = `bin/gherkin-generate-ast $file 2>&1`;
    my $expected = `cat $file.errors`;
    eq_or_diff( $result, $expected, "$file - errors");
}

done_testing();