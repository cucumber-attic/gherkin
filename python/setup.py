# coding: utf-8
from distutils.core import setup
setup(
  name = 'gherkin3',
  packages = ['gherkin3'],
  version = '3.1.0',
  description = 'Gherkin parser',
  author = 'Björn Rasmusson',
  author_email = 'cukes@googlegroups.com',
  url = 'https://github.com/cucumber/gherkin-python',
  license = 'MIT',
  download_url = 'https://github.com/cucumber/gherkin-python/archive/v3.1.0.tar.gz',
  keywords = ['gherkin', 'cucumber', 'bdd'],
  classifiers = [],
  package_data = {'gherkin3': ['gherkin-languages.json']},
)
