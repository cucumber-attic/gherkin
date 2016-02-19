package Gherkin::AstNode;

use Moose;

has 'rule_type' => ( is => 'ro', isa => 'Str', required => 1 );
has '_sub_items' => ( is => 'ro', isa => 'HashRef', default => sub { {} } );

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    $class->$orig( { rule_type => $_[0] } );
};

sub add {
    my ( $self, $rule_type, $obj ) = @_;
    push( @{ ( $self->_sub_items->{$rule_type} ||= [] ) }, $obj );
}

sub get_single {
    my ( $self, $rule_type ) = @_;
    my $items = $self->_sub_items->{$rule_type};
    return $items unless $items;
    return $items->[0];
}

sub get_items {
    my ( $self, $rule_type ) = @_;
    return $self->_sub_items->{$rule_type};
}

sub get_token {
    my ( $self, $token_type ) = @_;
    return $self->get_single($token_type);
}

sub get_tokens {
    my ( $self, $token_type ) = @_;
    return $self->_sub_items->{$token_type};
}

1;
