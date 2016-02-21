package Gherkin::ParserContext;

use Moo;
use Types::Standard qw(InstanceOf ArrayRef);

has 'token_scanner' => (
    is       => 'ro',
    isa      => InstanceOf ['Gherkin::TokenScanner'],
    required => 1
);
has 'token_matcher' => (
    is       => 'ro',
    isa      => InstanceOf ['Gherkin::TokenMatcher'],
    required => 1
);

has 'token_queue' => (
    is      => 'ro',
    isa     => ArrayRef,
    default => sub { [] },
);

has '_errors' => (
    is      => 'ro',
    isa     => ArrayRef,
    default => sub { [] },

);

# Would be traits, but not with Moo
sub add_tokens { my $self = shift; push( @{ $self->token_queue }, @_ ); }
sub errors     { my $self = shift; return @{ $self->_errors } }
sub add_errors { my $self = shift; push( @{ $self->_errors },     @_ ); }

sub read_token {
    my ($self) = shift();
    return shift( @{ $self->token_queue } ) || $self->token_scanner->read;
}

1;
