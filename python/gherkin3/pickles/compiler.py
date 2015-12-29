import re

from ..dialect import Dialect
from ..count_symbols import count_symbols

def compile(feature, path):
    pickles = []
    dialect = feature['language']
    feature_tags = feature['tags']
    background_steps = _get_background_steps(feature, path)
    for scenario_definition in feature['scenarioDefinitions']:
        args = (feature_tags, background_steps, scenario_definition,
                dialect, path, pickles)
        if scenario_definition['type'] is 'Scenario':
            _compile_scenario(*args)
        else:
            _compile_scenario_outline(*args)
    return pickles


def _compile_scenario(feature_tags, background_steps, scenario,
                      dialect, path, pickles):
    steps = list(background_steps)
    tags = list(feature_tags) + list(scenario['tags'])

    for step in scenario['steps']:
        steps.append(_pickle_step(step, path))

    pickle = {
        'tags': _pickle_tags(tags, path),
        'name': u'{0[keyword]}: {0[name]}'.format(scenario),
        'locations': [_pickle_location(scenario['location'], path)],
        'steps': steps
    }
    pickles.append(pickle)


def _compile_scenario_outline(feature_tags, background_steps, scenario_outline,
                              dialect, path, pickles):
    keyword = Dialect.for_name(dialect).scenario_keywords[0]

    for examples in scenario_outline['examples']:
        variable_cells = examples['tableHeader']['cells']

        for values in examples['tableBody']:
            value_cells = values['cells']
            steps = list(background_steps)
            tags = list(feature_tags) \
                + list(scenario_outline['tags']) \
                + list(examples['tags'])

            for scenario_outline_step in scenario_outline['steps']:
                step_text = _interpolate(
                    scenario_outline_step['text'],
                    variable_cells,
                    value_cells)
                arguments = _create_pickle_arguments(
                    scenario_outline_step.get('argument'),
                    variable_cells,
                    value_cells,
                    path)
                _pickle_step = {
                    'text': step_text,
                    'arguments': arguments,
                    'locations': [
                        _pickle_location(values['location'], path),
                        _pickle_step_location(scenario_outline_step, path)
                    ]
                }
                steps.append(_pickle_step)

            pickle = {
                'name': u'{0}: {1}'.format(
                    keyword,
                    _interpolate(
                        scenario_outline['name'],
                        variable_cells,
                        value_cells)
                    ),
                'steps': steps,
                'tags': _pickle_tags(tags, path),
                'locations': [
                    _pickle_location(values['location'], path),
                    _pickle_location(scenario_outline['location'], path)
                ]
            }
            pickles.append(pickle)


def _create_pickle_arguments(argument, variables, values, path):
    result = []

    if not argument:
        return result

    if argument['type'] is 'DataTable':
        table = {'rows': []}
        for row in argument['rows']:
            cells = [
                {
                    'location': _pickle_location(cell['location'], path),
                    'value': _interpolate(cell['value'], variables, values)
                } for cell in row['cells']
            ]
            table['rows'].append({'cells': cells})
        result.append(table)

    elif argument['type'] is 'DocString':
        docstring = {
            'location': _pickle_location(argument['location'], path),
            'content': _interpolate(argument['content'], variables, values)
        }
        result.append(docstring)

    else:
        raise Exception('Internal error')

    return result


def _interpolate(name, variable_cells, value_cells):
    for n, variable_cell in enumerate(variable_cells):
        value_cell = value_cells[n]
        name = re.sub(
            u'<{0[value]}>'.format(variable_cell),
            value_cell['value'],
            name
            )
    return name


def _get_background_steps(feature, path):
    if 'background' in feature:
        return [_pickle_step(step, path)
                for step in feature['background']['steps']]
    return []


def _pickle_step(step, path):
    return {
        'text': step['text'],
        'arguments': _create_pickle_arguments(
            step.get('argument'),
            [],
            [],
            path),
        'locations': [_pickle_step_location(step, path)]
    }


def _pickle_step_location(step, path):
    return {
        'path': path,
        'line': step['location']['line'],
        'column': step['location']['column'] + count_symbols(step.get('keyword', 0))
    }


def _pickle_location(location, path):
    return {
        'path': path,
        'line': location['line'],
        'column': location['column']
    }


def _pickle_tags(tags, path):
    return [_pickle_tag(tag, path) for tag in tags]


def _pickle_tag(tag, path):
    return {
        'name': tag['name'],
        'location': _pickle_location(tag['location'], path)
    }
