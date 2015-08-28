import os
import json


class Dialect(object):
    DIALECTS = json.load(open(os.path.join(os.path.dirname(__file__),
                                           'gherkin-languages.json'), 'r'), encoding='utf-8')

    @classmethod
    def for_name(cls, name):
        return cls(cls.DIALECTS[name]) if name in cls.DIALECTS else None

    def __init__(self, spec):
        self.spec = spec

    def feature_keywords(self):
        return self.spec['feature']

    def scenario_keywords(self):
        return self.spec['scenario']

    def scenario_outline_keywords(self):
        return self.spec['scenarioOutline']

    def background_keywords(self):
        return self.spec['background']

    def examples_keywords(self):
        return self.spec['examples']

    def given_keywords(self):
        return self.spec['given']

    def when_keywords(self):
        return self.spec['when']

    def then_keywords(self):
        return self.spec['then']

    def and_keywords(self):
        return self.spec['and']

    def but_keywords(self):
        return self.spec['but']
