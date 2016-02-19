package Gherkin::TokenScanner;

use Moose;

use IO::File;
use IO::Scalar;
use Carp qw/croak/;

use Gherkin::Line;
use Gherkin::Token;
use Gherkin::TokenMatcher;

has 'fh' => ( is => 'ro', isa => 'IO::Handle', required => 1 );
has 'line_number' => (
    is      => 'rw',
    isa     => 'Int',
    traits  => ['Counter'],
    default => 0,
    handles => { next_line => 'inc' }
);

around BUILDARGS => sub {
    my ( $orig, $class, $path_or_str ) = @_;

   # Perl convention is that a string reference is the string itself, but that
   # a straight string is a path
    my $fh;
    if ( ref $path_or_str eq 'SCALAR' ) {
        my $data = $path_or_str;
        $fh = new IO::Scalar \$path_or_str;
    }
    else {
        $fh = IO::File->new();
        $fh->open( $path_or_str, '<')
            || croak "Can't open [$path_or_str] for reading";
        $fh->binmode(':utf8');
    }

    return $class->$orig( { fh => $fh } );
};

sub read {
    my $self = shift;
    $self->next_line();
    my $line = $self->fh->getline;
    return Gherkin::Token->new(
        line => $line ? (Gherkin::Line->new(
            { line_text => $line, line_number => $self->line_number }
        )) : undef,
        location => { line => $self->line_number }
    );
}

sub DESTROY {
    my $self = shift;
    if ( $self->fh ) {
        $self->fh->close;
    }
}

1;
