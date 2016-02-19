package Gherkin::Dialect;

use Moose;

use FindBin qw($Bin);
use Path::Class qw/file/;
use JSON::MaybeXS qw/decode_json/;

has 'dialect' => (
    is      => 'rw',
    isa     => 'Str',
    trigger => sub {
        my ( $self, $name, $location ) = @_;
        die Gherkin::Exceptions::NoSuchLanguage->new( $name, $location )
            unless $self->dictionary->{$name};
    }
);

has 'dictionary_location' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        '' . file($Bin)->parent->file('gherkin-languages.json');
    },
);

has 'dictionary' => (
    is         => 'rw',
    lazy_build => 1
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
