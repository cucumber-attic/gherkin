# coding=utf-8
from gherkin.token_scanner import TokenScanner
from gherkin.token_matcher import TokenMatcher
from gherkin.parser import Parser
from gherkin.errors import ParserError
from nose.tools import assert_equals, assert_raises


def test_parser():
    parser = Parser()
    feature = parser.parse(TokenScanner("Feature: Foo"))
    expected = {
        'comments': [],
        'keyword': u'Feature',
        'language': 'en',
        'location': {'column': 1, 'line': 1},
        'name': u'Foo',
        'scenarioDefinitions': [],
        'tags': [],
        'type': 'Feature'}

    assert_equals(expected, feature)


def test_parse_multiple_features():
    parser = Parser()
    f1 = parser.parse(TokenScanner("Feature: 1"))
    f2 = parser.parse(TokenScanner("Feature: 2"))

    assert_equals("1", f1['name'])
    assert_equals("2", f2['name'])


def test_parse_feature_after_parser_error():
    parser = Parser()
    with assert_raises(ParserError):
        parser.parse(TokenScanner('# a comment\n' +
                                  'Feature: Foo\n' +
                                  '  Scenario: Bar\n' +
                                  '    Given x\n' +
                                  '      ```\n' +
                                  '      unclosed docstring\n'))
    feature = parser.parse(TokenScanner('Feature: Foo\n' +
                                        '  Scenario: Bar\n' +
                                        '    Given x\n'
                                        '      """\n'
                                        '      closed docstring\n'
                                        '      """\n'))
    expected = [{
        'name': u'Bar',
        'keyword': u'Scenario',
        'tags': [],
        'steps': [{
            'text': u'x',
            'type': 'Step',
            'location': {'column': 5, 'line': 3},
            'keyword': u'Given ',
            'argument': {
                'content': u'closed docstring',
                'type': 'DocString',
                'location': {'column': 7, 'line': 4}}}],
        'location': {'column': 3, 'line': 2},
        'type': 'Scenario'}]

    assert_equals(expected, feature['scenarioDefinitions'])


def test_change_the_default_language():
    parser = Parser()
    matcher = TokenMatcher('no')
    feature = parser.parse(TokenScanner("Egenskap: i18n support - åæø"), matcher)
    expected = {
        'comments': [],
        'keyword': u'Egenskap',
        'language': 'no',
        'location': {'column': 1, 'line': 1},
        'name': u'i18n support - åæø',
        'scenarioDefinitions': [],
        'tags': [],
        'type': 'Feature'}

    assert_equals(expected, feature)
