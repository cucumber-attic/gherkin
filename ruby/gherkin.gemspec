# encoding: utf-8
Gem::Specification.new do |s|
  s.name        = 'gherkin'
  s.version     = '4.0.0'
  s.authors     = ["Gáspár Nagy", "Aslak Hellesøy", "Steve Tooke"]
  s.description = 'Gherkin parser'
  s.summary     = "gherkin-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = "https://github.com/cucumber/gherkin"
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.required_ruby_version = ">= 1.9.3"

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake',      '~> 10.5'
  s.add_development_dependency 'rspec',     '~> 3.5'

  # For coverage reports
  s.add_development_dependency 'coveralls', '~> 0.8.7', '< 0.8.18'

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ }
  s.test_files       = `git ls-files -- spec/*`.split("\n")
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
