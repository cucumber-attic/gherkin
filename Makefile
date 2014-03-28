all: csharp ruby
.PHONY: all

csharp:
	cd csharp && make test
.PHONY: csharp

ruby:
	cd ruby && bundle && bundle exec rake
.PHONY: ruby
