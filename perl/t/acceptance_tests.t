#!perl

use strict;
use warnings;

use Test::More;
use Test::Differences;
use Test::Exception;

use IO::Scalar;

require 'bin/gherkin-generate-ast';
require 'bin/gherkin-generate-pickles';
require 'bin/gherkin-generate-tokens';

my @good_files = glob("acceptance/testdata/good/*.feature");

for my $file ( @good_files ) {
    for my $type (qw/tokens ast pickles/) {
        my $result = "";
        my $class = 'App::GherkinGenerate' . ucfirst( $type );
        $class->run( (new IO::Scalar \$result), $file );
        my $expected = `cat $file.$type*`;

        $expected =~ s!../testdata/!acceptance/testdata/!g;
        eq_or_diff( $result, $expected, "$file - $type");
    }
}

my @bad_files = glob("acceptance/testdata/bad/*.feature");

for my $file ( @bad_files ) {
    my $result = "";
    my $class = 'App::GherkinGenerateAst';
    my $expected = `cat $file.errors`;

    dies_ok { $class->run( (new IO::Scalar \$result), $file ) }
        "$file - throws";
    eq_or_diff( "$@", $expected, "$file - correct errors");
}

done_testing();