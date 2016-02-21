package Gherkin::ParserBase;
use Moo;
use Types::Standard qw(Bool Int InstanceOf);

use TryCatch;

use Gherkin::ParserContext;
use Gherkin::Exceptions;
use Gherkin::AstBuilder;

use Gherkin::TokenMatcher;
use Gherkin::TokenScanner;

has 'ast_builder' => ( is => 'rw', isa => InstanceOf['Gherkin::AstBuilder'],
    default => sub { Gherkin::AstBuilder->new() },
    handles => {
        get_result => 'get_result',
    }
);

has 'stop_at_first_error' => ( is => 'rw', isa => Bool, default => 0 );
has 'max_errors' => ( is => 'rw', isa => Int, default => 10 );

sub parse {
    my ( $self, $token_scanner, $token_matcher ) = @_;

    $token_matcher ||= Gherkin::TokenMatcher->new();
    $token_scanner = Gherkin::TokenScanner->new( $token_scanner )
        unless ref $token_scanner;

    $self->ast_builder->reset();
    $token_matcher->reset();

    my $context = Gherkin::ParserContext->new({
        token_scanner => $token_scanner,
        token_matcher => $token_matcher,
    });

    $self->_start_rule( $context, 'Feature' );

    my $state = 0;
    my $token;

    while ( 1 ) {
        $token = $context->read_token( $context );
        $state = $self->match_token( $state, $token, $context );

        last if $token->is_eof();
    }

    $self->_end_rule( $context, 'Feature' );

    if ( my @errors = $context->errors ) {
        Gherkin::Exceptions::CompositeParser->throw( @errors );
    }

    return $self->get_result();
}

sub add_error {
    my ( $self, $context, $error ) = @_;

    $context->add_errors( $error );

    my @errors = $context->errors;
    Gherkin::Exceptions::CompositeParser->throw( @errors )
        if @errors > $self->max_errors;
}

sub _start_rule {
    my ( $self, $context, $ruleType ) = @_;
    $self->_handle_ast_error( $context, start_rule => $ruleType );
}

sub _end_rule {
    my ( $self, $context, $ruleType ) = @_;
    $self->_handle_ast_error( $context, end_rule => $ruleType );
}

sub _build {
    my ( $self, $context, $token ) = @_;
    $self->_handle_ast_error( $context, build => $token );
}

sub _handle_ast_error {
    my ( $self, $context, $method_name, $arg ) = @_;
    my $action = sub {
        $self->ast_builder->$method_name( $arg );
    };

    $self->handle_external_error( $context, 1, $action );
}

sub handle_external_error {
    my ( $self, $context, $default_value, $action ) = @_;
    return $action->() if $self->stop_at_first_error;

    try {
        return $action->();
    }
    catch (Gherkin::Exceptions::CompositeParser $e) {
        $self->add_error( $context, $_ ) for @{ $e->errors };
        return $default_value;
    }
    catch (Gherkin::Exceptions::SingleParser $e) {
        $self->add_error( $context, $e );
        return $default_value;
    }
}


1;