package Gherkin::TokenScanner;

use strict;
use warnings;

use Class::XSAccessor accessors =>
  [qw/fh line_number line_history line_queue filename/];

use IO::File;
use IO::Scalar;
use Carp qw/croak/;

use Gherkin::Line;
use Gherkin::Token;
use Gherkin::TokenMatcher;

sub new {
    my ( $class, $path_or_str, $filename ) = @_;

    # Perl convention is that a string reference is the string itself, but
    # that a straight string is a path
    my $fh;

    if ( ref $path_or_str eq 'SCALAR' ) {
        my $data = $path_or_str;
        $fh = new IO::Scalar \$path_or_str;
        $filename ||= '(unknown)';
    } else {
        $fh = IO::File->new();
        $fh->open( $path_or_str, '<' )
          || croak "Can't open [$path_or_str] for reading";
        $fh->binmode(':utf8');
        $filename ||= $path_or_str;
    }

    return bless {
        fh           => $fh,
        filename     => $filename,
        line_number  => 0,
        line_history => [],
        line_queue   => []
    }, $class;
}

sub next_line {
    my $self = shift;
    $self->line_number( $self->line_number + 1 );
}

sub read {
    my $self = shift;
    $self->next_line();

    # Take the next line from the queue, or from the filehandle
    my $line =
      ( shift( @{ $self->line_queue } ) || $self->_line_from_filehandle );

    # Add this line to the history
    push( @{ $self->line_history }, $line );
    return Gherkin::Token->new(
        line => $line
        ? (
            Gherkin::Line->new(
                {
                    line_text   => $line,
                    line_number => $self->line_number,
                }
            )
          )
        : undef,
        location => {
            line     => $self->line_number,
            context  => $self->line_context,
            filename => $self->filename
        }
    );
}

sub _fill_queue {
    my ( $self, $count ) = @_;
    while (( @{ $self->line_queue } < $count )
        && ( $count-- )
        && ( defined( my $line = $self->_line_from_filehandle ) ) )
    {
        push( @{ $self->line_queue }, $line );
    }
}

sub line_context {
    my ( $self, $wanted_before, $wanted_after ) = @_;
    $wanted_before = 2 unless defined $wanted_before;
    $wanted_after  = 2 unless defined $wanted_after;

    my $before = [];
    my $after  = [];

    # If we don't have enough lines in one direction, we'll get them from the
    # other.
    $self->_fill_queue( $before + $after );

    # Set to the last item (which is the current line) - 1, and attempt to get
    # the desired number of lines from `before`
    my $before_cursor = $#{ $self->line_history } - 1;
    while ( $before_cursor >= 0 && $wanted_before ) {
        unshift( @$before, $self->line_history->[$before_cursor] );
        $before_cursor--;
        $wanted_before--;
    }

    # Add any items we couldn't get from `before` to `after`. For example, we're
    # at line 1 already, so there are no before lines, and we want to show
    # context from before.
    $wanted_after += $wanted_before;
    my $after_cursor = 0;
    while ( $after_cursor <= $#{ $self->line_queue } && $wanted_after ) {
        push( @$after, $self->line_queue->[$after_cursor] );
        $after_cursor++;
        $wanted_after--;
    }

    # Add any items we couldn't get from `after` to `before` again; for example
    # we're at the end of the file, and there were no after lines to get, so we
    # want all the context from before.
    $wanted_before += $wanted_after;
    while ( $before_cursor >= 0 && $wanted_before ) {
        unshift( @$before, $self->line_history->[$before_cursor] );
        $before_cursor--;
        $wanted_before--;
    }

    return {
        before  => $before,
        current => $self->line_history->[-1],
        after   => $after,
    };
}

sub _line_from_filehandle {
    my $self = shift;
    return $self->fh->getline;
}

sub DESTROY {
    my $self = shift;
    if ( $self->fh ) {
        $self->fh->close;
    }
}

1;
