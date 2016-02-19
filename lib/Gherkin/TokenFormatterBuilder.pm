package Gherkin::TokenFormatterBuilder;

use Moose;
extends 'Gherkin::AstBuilder';

has 'formatted_tokens' =>
    ( is => 'rw', traits => ['Array'], default => sub { [] }, handles => {
        add_formatted_token => 'push',
        } );

after 'reset' => sub {
    my $self = shift;
    $self->formatted_tokens( [] );
};

sub build {
    my ( $self, $token ) = @_;
    $self->add_formatted_token( $self->format_token($token) );
}

sub start_rule { }
sub end_rule   { }

sub get_result {
    my $self = shift;
    return $self->formatted_tokens;
}

my $c = 0;

sub format_token {
    my ( $self, $token ) = @_;
    return "EOF" if $token->is_eof;
    my $v = sprintf(
        "(%s:%s)%s:%s/%s/%s",
        $token->location->{'line'},
        $token->location->{'column'},
        $token->matched_type,
        $token->matched_keyword || '',
        $token->matched_text || '',
        join( ',',
            map { $_->{'column'} . ':' . $_->{'text'} }
                @{ $token->matched_items } )
    );
    utf8::encode( $v );
    return $v;
}

1;
