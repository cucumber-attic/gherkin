from __future__ import print_function
import json
import textwrap

from gherkin3.token_scanner import TokenScanner
from gherkin3.token_matcher import TokenMatcher
from gherkin3.parser import Parser
from gherkin3.errors import ParserError
from gherkin3.pickles import compiler

from nose.tools import assert_equals, assert_raises

def test_compiles_a_scenario():
    feature_text = textwrap.dedent(
        """\
        Feature: f
          Scenario: s
            Given passing
        """)
    output  = Parser().parse(feature_text)
    pickle  = compiler.compile(output, 'features/hello.feature')
    expected_pickle = textwrap.dedent(
        """\
        [
          {
            "path": "features/hello.feature",
            "name": "Scenario: s",
            "steps": [
              {
                "text": "passing",
                "arguments": [],
                "locations": [
                  {
                    "line": 3,
                    "column": 11,
                    "path": "features/hello.feature"
                  }
                ]
              }
            ],
            "tags": [],
            "locations": [
              {
                "line": 2,
                "column": 3,
                "path": "features/hello.feature"
              }
            ]
          }
        ]
        """
    )
    
    assert_equals(
        pickle, 
        json.loads(expected_pickle)
    )
