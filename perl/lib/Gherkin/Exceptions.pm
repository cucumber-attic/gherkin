use strict;
use warnings;

package Gherkin::Exceptions;

use overload
  q{""}    => 'stringify',
  fallback => 1;

sub stringify { my $self  = shift; $self->message . "\n" }
sub throw     { my $class = shift; die $class->new(@_) }

# Parent of single and composite exceptions
package Gherkin::Exceptions::Parser;

use base 'Gherkin::Exceptions';

# Composite exceptions
package Gherkin::Exceptions::CompositeParser;

use base 'Gherkin::Exceptions::Parser';

sub new {
    my $class = shift;
    bless { errors => [@_], }, $class;
}

sub message {
    my $class = shift;
    return ( join '', ( "Parser errors:\n", @{ $class->{'errors'} } ) );
}

sub throw { my $class = shift; die $class->new(@_) }

#
# Various non-composite exceptions
#
package Gherkin::Exceptions::SingleParser;

use List::Util qw/max/;
use base 'Gherkin::Exceptions::Parser';

sub new {
    my ( $class, $message, $location ) = @_;
    bless {
        location         => $location,
        original_message => $message,
    }, $class;
}

sub message {
    my $self = shift;
    return $self->context_message;
    return sprintf( '(%i:%i): %s',
        $self->{'location'}->{'line'},
        $self->{'location'}->{'column'} || '0',
        $self->{'original_message'} );
}

sub context_message {
    my $self = shift;

    my $template = <<'ERROR';
-- %s Error --

%s
  at [%s] line %d, column %d

-- [%s] --

%s
--%s--
ERROR

    my ($error_class) = ( ref($self) =~ m/::([^:]+)$/g );

    my $location = $self->{'location'};
    my $context_line_number =
      $location->{'line'} - @{ $location->{'context'}->{'before'} };

    my $context_template = "% 4d| %s";

    my $context_string = join '',
      map { sprintf( $context_template, $context_line_number++, $_ ) }
      @{ $location->{'context'}->{'before'} },
      ( $location->{'context'}->{'current'} || '' );

    # If we're EOF, might be missing a newline, which would make the next line
    # a bit weird
    $context_string .= "\n" unless $context_string =~ m/\n$/;

    # Add a caret to show the column
    $context_string .= ( ' ' x 4 ) .    # Line number indent
      '+' .                             # Instead of the pipe delimiter
      ( '-' x 1 ) .                     # Demonstrate fake leading space
      ( ' ' x ( ( $location->{'column'} || 1 ) - 1 ) ) .    # Column indent
      "^\n";                                                # The marker itself

    $context_string .= join '',
      map { sprintf( $context_template, $context_line_number++, $_ ) }
      @{ $location->{'context'}->{'after'} };

    return sprintf( $template,
        $error_class,
        $self->{'original_message'},
        $location->{'filename'},
        $location->{'line'},
        ( $location->{'column'} || 0 ),
        $location->{'filename'},
        $context_string,
        ( '-' x ( 4 + length( $location->{'filename'} ) ) ),
    );
}

package Gherkin::Exceptions::NoSuchLanguage;

use base 'Gherkin::Exceptions::SingleParser';

sub new {
    my ( $class, $language, $location ) = @_;
    return $class->SUPER::new( "Language not supported: $language",
        $location, );
}

package Gherkin::Exceptions::AstBuilder;

use base 'Gherkin::Exceptions::SingleParser';

package Gherkin::Exceptions::UnexpectedEOF;

use base 'Gherkin::Exceptions::SingleParser';

sub new {
    my ( $class, $received_token, $expected_token_types ) = @_;
    return $class->SUPER::new(
        'unexpected end of file, expected: '
          . ( join ', ', @$expected_token_types ),
        $received_token->location,
    );
}

package Gherkin::Exceptions::UnexpectedToken;

use base 'Gherkin::Exceptions::SingleParser';

sub new {
    my ( $class, $received_token, $expected_token_types, $state_comment ) = @_;

    my $received_token_value = $received_token->token_value;
    $received_token_value =~ s/^\s+//;
    $received_token_value =~ s/\s+$//;

    my $message =
        "expected: "
      . ( join ', ', @$expected_token_types )
      . ", got '$received_token_value'";

    my %location = %{ $received_token->location };
    $location{'column'} = $received_token->line->indent + 1
      unless defined $location{'column'};

    return $class->SUPER::new( $message, \%location );
}

1;
