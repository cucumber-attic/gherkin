all: csharp ruby
.PHONY: all

csharp:
	cd csharp && make && nunit.sh
.PHONY: csharp

ruby:
	cd ruby && bundle && bundle exec rake
.PHONY: ruby
