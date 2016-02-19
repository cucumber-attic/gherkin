package Gherkin::Token;

use Moose;

has 'line' => ( is => 'ro', isa => 'Gherkin::Line|Undef' );
has 'location' => ( is => 'ro', isa => 'HashRef', required => 1 );

has 'matched_type' => ( is => 'rw', isa => 'Str' );
has 'matched_keyword' => ( is => 'rw', isa => 'Str' );
has 'matched_indent' => ( is => 'rw', isa => 'Int' );
has 'matched_items' => ( is => 'rw' );
has 'matched_text' => ( is => 'rw', isa => 'Str' );
has 'matched_gherkin_dialect' => ( is => 'rw', isa => 'Str' );

sub is_eof { my $self = shift; return ! $self->line };
sub detach {}
sub token_value {
    my $self = shift;
    return $self->is_eof ? "EOF" : $self->line->get_line_text;
}

1;