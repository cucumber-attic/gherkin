use strict;
use warnings;

package Gherkin::Exceptions;
    use overload
        q{""}    => 'stringify',
        fallback => 1;

    sub stringify { my $self  = shift; $self->{'message'} . "\n" }
    sub message   { my $self  = shift; $self->{'message'} }
    sub throw     { my $class = shift; die $class->new(@_) }

# Parent of single and composite exceptions
package Gherkin::Exceptions::Parser;
    use base 'Gherkin::Exceptions';

# Composite exceptions
package Gherkin::Exceptions::CompositeParser;
    use base 'Gherkin::Exceptions::Parser';

    sub new {
        my $class = shift;
        bless {
            message => join "\n",
            ( 'Parser errors:', map { $_->{'message'} } @_ )
        }, $class;
    }

    sub throw { my $class = shift; die $class->new(@_) }

#
# Various non-composite exceptions
#
package Gherkin::Exceptions::SingleParser;
    use base 'Gherkin::Exceptions::Parser';

    sub new {
        my ( $class, $message, $location ) = @_;
        bless {
            message => sprintf( '(%i:%i): %s',
                $location->{'line'}, $location->{'column'} || '0',
                $message ),
        }, $class;
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
        my ( $class, $received_token, $expected_token_types, $state_comment )
            = @_;

        my $received_token_value = $received_token->token_value;
        $received_token_value =~ s/^\s+//;
        $received_token_value =~ s/\s+$//;

        my $message
            = "expected: "
            . ( join ', ', @$expected_token_types )
            . ", got '$received_token_value'";

        my %location = %{ $received_token->location };
        $location{'column'} = $received_token->line->indent + 1
            unless defined $location{'column'};

        return $class->SUPER::new( $message, \%location );
    }

1;
