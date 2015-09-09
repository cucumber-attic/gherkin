from .ast_node import AstNode
from .errors import AstBuilderException


def reject_nones(mapping):
    return {k: v for k, v in mapping.items() if v is not None}  # only None should be rejected

def get_location(token, column=None):
    # TODO: translated from JS... is it right?
    return (token.location if (not column or column == 0) else
            {'line': token.location['line'], 'column': column})

def get_tags(node):
    tags = []
    tags_node = node.get_single('Tags')
    if not tags_node:
        return tags
    for token in tags_node.get_tokens('TagLine'):
        tags += [{'type': 'Tag',
                  'location': get_location(token, tag_item['column']),
                  'name': tag_item['text']} for tag_item in token.matched_items]
    return tags

def get_table_rows(node):
    def ensure_cell_count(rows):
        if not rows:
            return
        cell_count = len(rows[0]['cells'])
        for row in rows:
            if len(row['cells']) != cell_count:
                raise AstBuilderException('inconsistent cell count within the table',
                                          row['location'])

    def get_cells(table_row_token):
        return [{'type':     'TableCell',
                 'location': get_location(table_row_token, cell_item['column']),
                 'value':    cell_item['text'] } for cell_item in table_row_token.matched_items]

    
    rows = [{'type': 'TableRow',
             'location': get_location(token),
             'cells': get_cells(token)} for token in node.get_tokens('TableRow')]
    ensure_cell_count(rows)
    return rows

def get_description(node):
    return node.get_single('Description')

def get_steps(node):
    return node.get_items('Step')


class AstBuilder(object):
    def __init__(self):
        self.reset()

    def reset(self):
        self.stack = [AstNode('None')]
        self.comments = []

    def start_rule(self, rule_type):
        self.stack.append(AstNode(rule_type))

    def end_rule(self, rule_type):
        node = self.stack.pop()
        self.current_node().add(node.rule_type, self.transform_node(node))

    def build(self, token):
        if token.matched_type == 'Comment':
            self.comments.append({
                'type': 'Comment',
                'location': get_location(token),
                'text': token.matched_text
            })
        else:
            self.current_node().add(token.matched_type, token)

    def get_result(self):
        return self.current_node().get_single('Feature')

    def current_node(self):
        return self.stack[-1]

    def transform_node(self, node):
        if node.rule_type == 'Step':
            step_line = node.get_token('StepLine')
            step_argument = None
            if node.get_single('DataTable'):
                step_argument = node.get_single('DataTable')
            elif node.get_single('DocString'):
                step_argument = node.get_single('DocString')

            return reject_nones({
                'type': node.rule_type,
                'location': get_location(step_line),
                'keyword': step_line.matched_keyword,
                'text': step_line.matched_text,
                'argument': step_argument
            })
        elif node.rule_type == 'DocString':
            separator_token = node.get_tokens('DocStringSeparator')[0]
            content_type = separator_token.matched_text
            line_tokens = node.get_tokens('Other')
            content = '\n'.join([t.matched_text for t in line_tokens])

            return reject_nones({
                'type': node.rule_type,
                'location': get_location(separator_token),
                'contentType': content_type,
                'content': content
            })
        elif node.rule_type == 'DataTable':
            rows = get_table_rows(node)
            return reject_nones({
                'type': node.rule_type,
                'location': rows[0]['location'],
                'rows': rows,
            })
        elif node.rule_type == 'Background':
            background_line = node.get_token('BackgroundLine')
            description = get_description(node)
            steps = get_steps(node)

            return reject_nones({
                'type': node.rule_type,
                'location': get_location(background_line),
                'keyword': background_line.matched_keyword,
                'name': background_line.matched_text,
                'description': description,
                'steps': steps
            })
        elif node.rule_type == 'Scenario_Definition':
            tags = get_tags(node)
            scenario_node = node.get_single('Scenario')
            if scenario_node:
                scenario_line = scenario_node.get_token('ScenarioLine')
                description = get_description(scenario_node)
                steps = get_steps(scenario_node)

                return reject_nones({
                    'type': scenario_node.rule_type,
                    'tags': tags,
                    'location': get_location(scenario_line),
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
                description = get_description(scenario_outline_node)
                steps = get_steps(scenario_outline_node)
                examples = scenario_outline_node.get_items('Examples_Definition')

                return reject_nones({
                    'type': scenario_outline_node.rule_type,
                    'tags': tags,
                    'location': get_location(scenario_outline_line),
                    'keyword': scenario_outline_line.matched_keyword,
                    'name': scenario_outline_line.matched_text,
                    'description': description,
                    'steps': steps,
                    'examples': examples
                })
        elif node.rule_type == 'Examples_Definition':
            tags = get_tags(node)
            examples_node = node.get_single('Examples')
            examples_line = examples_node.get_token('ExamplesLine')
            description = get_description(examples_node)
            rows = get_table_rows(examples_node)

            return reject_nones({
                'type': examples_node.rule_type,
                'tags': tags,
                'location': get_location(examples_line),
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

            tags = get_tags(header)
            feature_line = header.get_token('FeatureLine')
            if not feature_line:
                return

            background = node.get_single('Background')
            scenario_definitions = node.get_items('Scenario_Definition')
            description = get_description(header)
            language = feature_line.matched_gherkin_dialect

            return reject_nones({
                'type': node.rule_type,
                'tags': tags,
                'location': get_location(feature_line),
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
