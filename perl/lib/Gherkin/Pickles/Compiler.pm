package Gherkin::Pickles::Compiler;

use strict;
use warnings;

sub compile {
    my ( $class, $feature_file, $path ) = @_;
    my @pickles;

    my $feature = $feature_file->{'feature'};
    my $feature_tags     = $feature->{'tags'};
    my $background_steps = [];

    for my $scenario_definition ( @{ $feature->{'children'} } ) {
        my @args = (
            $feature_tags, $background_steps, $scenario_definition,
            $path, \@pickles
        );
        if ( $scenario_definition->{'type'} eq 'Background' ) {
            $background_steps = $class->_pickle_steps($scenario_definition, $path)
        } elsif ( $scenario_definition->{'type'} eq 'Scenario' ) {
            $class->_compile_scenario(@args);
        } else {
            $class->_compile_scenario_outline(@args);
        }
    }

    return \@pickles;
}

sub _pickle_steps {
    my ( $class, $scenario_definition, $path ) = @_;
    my @steps = map { $class->_pickle_step( $_, $path ) }
      @{ $scenario_definition->{'steps'} };
    return \@steps;
}

sub _compile_scenario {
    my ( $class, $feature_tags, $background_steps, $scenario,
        $path, $pickles )
      = @_;

    my $array_reference = $scenario->{'steps'};
    my @actual_array = @$array_reference;
    my $array_size = @actual_array;
    if ($array_size == 0) { return; }

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
            name => $scenario->{'name'},
            locations =>
              [ $class->_pickle_location( $scenario->{'location'}, $path ) ],
            steps => \@steps,
        }
    );
}

sub _compile_scenario_outline {
    my ( $class, $feature_tags, $background_steps, $scenario_outline,
        $path, $pickles )
      = @_;

    my $array_reference = $scenario_outline->{'steps'};
    my @actual_array = @$array_reference;
    my $array_size = @actual_array;
    if ($array_size == 0) { return; }

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
                    name =>
                        $class->_interpolate(
                            $scenario_outline->{'name'}, $variable_cells,
                            $value_cells,
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
