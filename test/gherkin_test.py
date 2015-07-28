from gherkin.token_scanner import TokenScanner
from gherkin.parser import Parser
from nose.tools import assert_equals

def test_parser():
    parser = Parser()
    feature = parser.parse(TokenScanner("Feature: Foo"))
    expected = {'comments': [],
     'keyword': u'Feature',
     'language': 'en',
     'location': {'column': 1, 'line': 1},
     'name': u'Foo',
     'scenarioDefinitions': [],
     'tags': [],
     'type': 'Feature'}

    assert_equals(expected, feature)
