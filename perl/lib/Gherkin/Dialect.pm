package Gherkin::Dialect;

use Moo;
use Types::Standard qw(Str HashRef);

use FindBin qw($Bin);
use Path::Class qw/file/;
use JSON::MaybeXS qw/decode_json/;
use Gherkin::Exceptions;

has 'dialect' => (
    is     => 'rw',
    isa    => Str,
    writer => 'set_dialect',
);

sub change_dialect {
    my ( $self, $name, $location ) = @_;
    Gherkin::Exceptions::NoSuchLanguage->throw( $name, $location )
        unless $self->dictionary->{$name};
    $self->set_dialect($name);
}

has 'dictionary_location' => (
    is      => 'ro',
    isa     => Str,
    default => sub {
        '' . file($Bin)->parent->file('gherkin-languages.json');
    },
);

has 'dictionary' => (
    is         => 'lazy',
    isa        => HashRef,
);

sub _build_dictionary {
    my $self = shift;
    decode_json scalar file( $self->dictionary_location )->slurp;
}

for my $key_name (
    qw/feature scenario scenarioOutline background examples
    given when then and but /
    )
{
    __PACKAGE__->meta->add_method(
        ucfirst($key_name) => sub {
            my $self = shift;
            return $self->dictionary->{ $self->dialect }->{$key_name};
        }
    );
}

1;
