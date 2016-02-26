package Gherkin::Pickles::Compiler;

use strict;
use warnings;

use Gherkin::Dialect;

sub compile {
    my ( $class, $feature, $path ) = @_;
    my @pickles;

    $path = $feature->{'location'}->{'context'}->{'filename'}
      unless defined $path;
    my $dialect          = $feature->{'language'};
    my $feature_tags     = $feature->{'tags'};
    my $background_steps = $class->_get_background_steps( $feature, $path );

    for my $scenario_definition ( @{ $feature->{'scenarioDefinitions'} } ) {
        my @args = (
            $feature_tags, $background_steps, $scenario_definition,
            $dialect, $path, \@pickles
        );
        if ( $scenario_definition->{'type'} eq 'Scenario' ) {
            $class->_compile_scenario(@args);
        } else {
            $class->_compile_scenario_outline(@args);
        }
    }

    return \@pickles;
}

sub _get_background_steps {
    my ( $class, $feature, $path ) = @_;
    my @steps;
    if ( $feature->{'background'} ) {
        @steps = map { $class->_pickle_step( $_, $path ) }
          @{ $feature->{'background'}->{'steps'} };
    }
    return \@steps;
}

sub _compile_scenario {
    my ( $class, $feature_tags, $background_steps, $scenario,
        $dialect, $path, $pickles )
      = @_;
    my @tags = ( @$feature_tags, @{ $scenario->{'tags'} || [] } );

    my @steps = (
        @$background_steps,
        map { $class->_pickle_step( $_, $path ) }
          @{ $scenario->{'steps'} || [] }
    );

    push(
        @$pickles,
        {
            tags => $class->_pickle_tags( \@tags, $path ),
            name =>
              sprintf( '%s: %s', $scenario->{'keyword'}, $scenario->{'name'} ),
            locations =>
              [ $class->_pickle_location( $scenario->{'location'}, $path ) ],
            steps => \@steps,
        }
    );
}

sub _compile_scenario_outline {
    my ( $class, $feature_tags, $background_steps, $scenario_outline,
        $dialect, $path, $pickles )
      = @_;

    my $dialect_object = Gherkin::Dialect->new( { dialect => $dialect } );
    my $keyword = $dialect_object->Scenario->[0];

    for my $examples ( @{ $scenario_outline->{'examples'} || [] } ) {
        my $variable_cells = $examples->{'tableHeader'}->{'cells'};

        for my $values ( @{ $examples->{'tableBody'} || [] } ) {
            my $value_cells = $values->{'cells'};
            my @steps       = @$background_steps;
            my @tags        = (
                @$feature_tags,
                @{ $scenario_outline->{'tags'} || [] },
                @{ $examples->{'tags'} || [] }
            );

            for my $scenario_outline_step ( @{ $scenario_outline->{'steps'} } )
            {
                my $step_text =
                  $class->_interpolate( $scenario_outline_step->{'text'},
                    $variable_cells, $value_cells, );
                my $arguments =
                  $class->_create_pickle_arguments(
                    $scenario_outline_step->{'argument'},
                    $variable_cells, $value_cells, $path, );
                push(
                    @steps,
                    {
                        text      => $step_text,
                        arguments => $arguments,
                        locations => [
                            $class->_pickle_location(
                                $values->{'location'}, $path
                            ),
                            $class->_pickle_step_location(
                                $scenario_outline_step, $path
                            ),
                        ]
                    }
                );
            }

            push(
                @$pickles,
                {
                    name => sprintf(
                        "%s: %s", $keyword,
                        $class->_interpolate(
                            $scenario_outline->{'name'}, $variable_cells,
                            $value_cells,
                        )
                    ),
                    steps     => \@steps,
                    tags      => $class->_pickle_tags( \@tags, $path ),
                    locations => [
                        $class->_pickle_location(
                            $values->{'location'}, $path
                        ),
                        $class->_pickle_location(
                            $scenario_outline->{'location'}, $path
                        ),
                    ],
                }
            );
        }
    }
}

sub _create_pickle_arguments {
    my ( $class, $argument, $variables, $values, $path ) = @_;
    my $result = [];

    return $result unless $argument;

    if ( $argument->{'type'} eq 'DataTable' ) {
        my $table = { rows => [] };
        for my $row ( @{ $argument->{'rows'} || [] } ) {
            my @cells = map {
                {
                    location =>
                      $class->_pickle_location( $_->{'location'}, $path ),
                    value => $class->_interpolate(
                        $_->{'value'}, $variables, $values
                    )
                }
            } @{ $row->{'cells'} || [] };
            push( @{ $table->{'rows'} }, { cells => \@cells } );
        }
        push( @$result, $table );
    } elsif ( $argument->{'type'} eq 'DocString' ) {
        push(
            @$result,
            {
                location =>
                  $class->_pickle_location( $argument->{'location'}, $path ),
                content => $class->_interpolate(
                    $argument->{'content'},
                    $variables, $values
                ),
            }
        );
    } else {
        die "Internal error";
    }

    return $result;
}

sub _interpolate {
    my ( $class, $name, $variable_cells, $value_cells ) = @_;
    my $n = 0;
    for my $variable_cell ( @{ $variable_cells || [] } ) {
        my $from = '<' . $variable_cell->{'value'} . '>';
        my $to   = $value_cells->[ $n++ ]->{'value'};
        $name =~ s/$from/$to/g;
    }
    return $name;
}

sub _pickle_step {
    my ( $class, $step, $path ) = @_;

    return {
        text => $step->{'text'},
        arguments =>
          $class->_create_pickle_arguments( $step->{'argument'}, [], [], $path,
          ),
        locations => [ $class->_pickle_step_location( $step, $path ) ],
    };
}

sub _pickle_step_location {
    my ( $class, $step, $path ) = @_;
    return {
        path   => $path,
        line   => $step->{'location'}->{'line'},
        column => $step->{'location'}->{'column'} +
          length( $step->{'keyword'} ),
    };
}

sub _pickle_location {
    my ( $class, $location, $path ) = @_;
    return {
        path   => $path,
        line   => $location->{'line'},
        column => $location->{'column'},
    };
}

sub _pickle_tags {
    my ( $class, $tags, $path ) = @_;
    return [ map { $class->_pickle_tag( $_, $path ) } @$tags ];
}

sub _pickle_tag {
    my ( $class, $tag, $path ) = @_;
    return {
        name     => $tag->{'name'},
        location => $class->_pickle_location( $tag->{'location'}, $path )
    };
}

1;
