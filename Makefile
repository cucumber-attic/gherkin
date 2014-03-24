all: csharp ruby
.PHONY: all

csharp:
	cd csharp && make
.PHONY: csharp

ruby:
	cd ruby && bundle && bundle exec rake
.PHONY: ruby
