all: csharp java ruby
.PHONY: all

csharp:
	cd csharp && make test
.PHONY: csharp

java:
	cd java && mvn test
.PHONY: java

ruby:
	cd ruby && bundle && bundle exec rake
.PHONY: ruby
