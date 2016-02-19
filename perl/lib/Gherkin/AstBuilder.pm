package Gherkin::AstBuilder;

use Moose;
use Gherkin::AstNode;

has 'stack'    => ( is => 'rw', traits => ['Array'] );
has 'comments' => ( is => 'rw', traits => ['Array'] );

sub ast_node { Gherkin::AstNode->new( $_[0] ) }

sub BUILD { $_[0]->reset() }

sub reset {
    my $self = shift;
    $self->stack( [ ast_node('None') ] );
    $self->comments( [] );
}

sub current_node {
    my $self = shift;
    return $self->stack->get(-1);
}

sub start_rule {
    my ( $self, $rule_type ) = @_;
    $self->stack->push( ast_node($rule_type) );
}

sub end_rule {
    my ( $self, $rule_type ) = @_;
    my $node = $self->stack->pop();
    $self->current_node->add( $node->rule_type,
        $self->transform_node($node) );
}

sub build {
    my ( $self, $token ) = @_;
    if ( $token->matched_type eq 'Comment' ) {
        $self->comments->push(
            {   type     => 'Comment',
                location => $self->get_location($token),
                text     => $token->matched_text,
            }
        );
    }
    else {
        $self->current_node->add( $token->matched_type, $token );
    }
}

sub get_result {
    my $self = shift;
    return $self->current_node->get_single('Feature');
}

sub get_location {
    my ( $self, $token, $column ) = @_;

    if ( !defined $column ) {
        return $token->location;
    }
    else {
        return {
            line   => $token->location->{'line'},
            column => $column,
        };
    }
}

sub get_tags {
    my ( $self, $node ) = @_;

    my $tags_node = $node->get_single('Tags') || return [];
    my @tags;

    for my $token ( $tags_node->get_tokens('TagLine') ) {
        for my $item ( @{ $token->matched_items } ) {
            push(
                @tags,
                {   type => 'Tag',
                    location =>
                        $self->get_location( $token, $item->{'column'} ),
                    name => $item->{'text'}
                }
            );
        }
    }

    return \@tags;
}

sub get_table_rows {
    my ( $self, $node ) = @_;
    my @rows;
    for my $token ( $node->get_tokens('Table_Row') ) {
        push(
            @rows,
            {   type     => 'TableRow',
                location => $self->get_location($token),
                cells    => $self->get_cells($token),
            }
        );
    }

    $self->ensure_cell_count( \@rows );

    return \@rows;
}

sub ensure_cell_count {
    my ( $self, $rows ) = @_;
    return unless @$rows;

    my $cell_count;

    for my $row (@$rows) {
        my $this_row_count = @{ $row->['cells'] };
        $cell_count = $this_row_count unless defined $cell_count;
        unless ( $cell_count == $this_row_count ) {
            die Gherkin::AstBuilderException->new(
                "inconsistent cell count within the table",
                $row->{'location'} );
        }
    }
}

sub get_cells {
    my ( $self, $table_row_token ) = @_;
    my @cells;
    for my $cell_item ( $table_row_token->matched_items ) {
        push(
            @cells,
            {   type     => 'TableCell',
                location => $self->get_location(
                    $table_row_token, $cell_item->{'column'}
                ),
            }
        );
    }

    return \@cells;
}

sub get_description { return $_[1]->get_single('Description') }
sub get_step        { return $_[1]->get_items('Step') }

sub reject_nones {
    my ( $self, $values ) = @_;

    my $defined_only = {};
    for my $key (%$values) {
        my $value = $values->{$key};
        $defined_only->{$key} = $value if defined $value;
    }

    return $defined_only;
}

sub transform_node {
    my ( $self, $node ) = @_;
    if ( $node->rule_type eq 'Step' ) {
        my $step_line = node->get_token('StepLine');
        my $step_argument
            = $node->get_single('DataTable')
            || $node->get_single('DocString')
            || undef;

        return $self->reject_nones({
            type => $node->rule_type,
            location => $self->get_location( $step_line ),
            keyword => $step_line->matched_keyword,
            text => $step_line->matched_text,
            argument => $step_argument,
        });
    } elsif ( $node->rule_type eq 'DocString' ) {
        my $separator_token = $node->get_tokens('DocStringSeparator')->[0];
        my $content_type = $separator_token->matched_text;
        $content_type = undef if length $content_type < 1;
        my $line_tokens = $node->get_tokens('Other');
        my $content = join("\n", map { $_->matched_text } @$line_tokens);

        return $self->reject_nones({
            type => $node->rule_type,
            location => $self->get_location( $separator_token ),
            contentType => $content_type,
            content => $content,
        });
    }
}

1;

__DATA__


        elif node.rule_type == 'DataTable':
            rows = self.get_table_rows(node)
            return self.reject_nones({
                'type': node.rule_type,
                'location': rows[0]['location'],
                'rows': rows,
            })
        elif node.rule_type == 'Background':
            background_line = node.get_token('BackgroundLine')
            description = self.get_description(node)
            steps = self.get_steps(node)

            return self.reject_nones({
                'type': node.rule_type,
                'location': self.get_location(background_line),
                'keyword': background_line.matched_keyword,
                'name': background_line.matched_text,
                'description': description,
                'steps': steps
            })
        elif node.rule_type == 'Scenario_Definition':
            tags = self.get_tags(node)
            scenario_node = node.get_single('Scenario')
            if scenario_node:
                scenario_line = scenario_node.get_token('ScenarioLine')
                description = self.get_description(scenario_node)
                steps = self.get_steps(scenario_node)

                return self.reject_nones({
                    'type': scenario_node.rule_type,
                    'tags': tags,
                    'location': self.get_location(scenario_line),
                    'keyword': scenario_line.matched_keyword,
                    'name': scenario_line.matched_text,
                    'description': description,
                    'steps': steps
                })
            else:
                scenario_outline_node = node.get_single('ScenarioOutline')
                if not scenario_outline_node:
                    raise RuntimeError('Internal grammar error')

                scenario_outline_line = scenario_outline_node.get_token('ScenarioOutlineLine')
                description = self.get_description(scenario_outline_node)
                steps = self.get_steps(scenario_outline_node)
                examples = scenario_outline_node.get_items('Examples_Definition')

                return self.reject_nones({
                    'type': scenario_outline_node.rule_type,
                    'tags': tags,
                    'location': self.get_location(scenario_outline_line),
                    'keyword': scenario_outline_line.matched_keyword,
                    'name': scenario_outline_line.matched_text,
                    'description': description,
                    'steps': steps,
                    'examples': examples
                })
        elif node.rule_type == 'Examples_Definition':
            tags = self.get_tags(node)
            examples_node = node.get_single('Examples')
            examples_line = examples_node.get_token('ExamplesLine')
            description = self.get_description(examples_node)
            rows = self.get_table_rows(examples_node)

            return self.reject_nones({
                'type': examples_node.rule_type,
                'tags': tags,
                'location': self.get_location(examples_line),
                'keyword': examples_line.matched_keyword,
                'name': examples_line.matched_text,
                'description': description,
                'tableHeader': rows[0],
                'tableBody': rows[1:]
            })
        elif node.rule_type == 'Description':
            line_tokens = node.get_tokens('Other')
            # Trim trailing empty lines
            last_non_empty = next(i for i, j in reversed(list(enumerate(line_tokens)))
                                  if j.matched_text)
            description = '\n'.join([token.matched_text for token in
                                     line_tokens[:last_non_empty + 1]])

            return description
        elif node.rule_type == 'Feature':
            header = node.get_single('Feature_Header')
            if not header:
                return

            tags = self.get_tags(header)
            feature_line = header.get_token('FeatureLine')
            if not feature_line:
                return

            background = node.get_single('Background')
            scenario_definitions = node.get_items('Scenario_Definition')
            description = self.get_description(header)
            language = feature_line.matched_gherkin_dialect

            return self.reject_nones({
                'type': node.rule_type,
                'tags': tags,
                'location': self.get_location(feature_line),
                'language': language,
                'keyword': feature_line.matched_keyword,
                'name': feature_line.matched_text,
                'description': description,
                'background': background,
                'scenarioDefinitions': scenario_definitions,
                'comments': self.comments
            })
        else:
            return node

