package Gherkin::ParserContext;

use Moose;

has 'token_scanner' =>
    ( is => 'ro', isa => 'Gherkin::TokenScanner', required => 1 );
has 'token_matcher' =>
    ( is => 'ro', isa => 'Gherkin::TokenMatcher', required => 1 );

has 'token_queue' => (
    is => 'ro',
    traits => ['Array'],
    default => sub {[]},
    handles => {
        add_tokens => 'push',
    }
);

has '_errors' => (
    is => 'ro',
    traits => ['Array'],
    default => sub {[]},
    handles => {
        errors => 'elements',
        add_errors => 'push',
    }
);

sub read_token {
    my ( $self ) = shift();
    return shift( @{$self->token_queue} ) || $self->token_scanner->read;
}

1;
