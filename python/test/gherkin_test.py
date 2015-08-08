from gherkin3.token_scanner import TokenScanner
from gherkin3.parser import Parser
from gherkin3.ast_builder import AstBuilder
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

def test_parser():
    ast_builder = AstBuilder()
    parser = Parser(ast_builder)
    f1 = parser.parse(TokenScanner("Feature: 1"))
    f2 = parser.parse(TokenScanner("Feature: 2"))

    assert_equals("1", f1['name'])
    assert_equals("2", f2['name'])
