# coding: utf-8
from distutils.core import setup
setup(
  name = 'gherkin3',
  packages = ['gherkin3'],
  version = '3.1.2',
  description = 'Gherkin parser',
  author = 'Björn Rasmusson',
  author_email = 'cukes@googlegroups.com',
  url = 'https://github.com/cucumber/gherkin-python',
  license = 'MIT',
  download_url = 'https://github.com/cucumber/gherkin-python/archive/v3.1.2.tar.gz',
  keywords = ['gherkin', 'cucumber', 'bdd'],
  classifiers = [
    'Programming Language :: Python',
    'Programming Language :: Python :: 2',
    'Programming Language :: Python :: 3',
  ],
  package_data = {'gherkin3': ['gherkin-languages.json']},
)
