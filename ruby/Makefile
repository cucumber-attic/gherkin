GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
AST      = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast,$(GOOD_FEATURE_FILES))

RUBY_FILES = $(shell find . -name "*.rb")

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(AST)
	touch $@

.built: lib/gherkin/parser.rb $(RUBY_FILES)
	bundle exec rspec
	touch $@

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	bundle exec ruby bin/gherkin-generate-tokens $< > $@
	diff --unified --ignore-all-space $<.tokens $@ || rm $@

acceptance/testdata/%.feature.ast: ../testdata/%.feature ../testdata/%.feature.ast .built
	mkdir -p `dirname $@`
	bundle exec ruby bin/gherkin-generate-ast $< > $@
	diff --unified --ignore-all-space $<.ast $@ || rm $@

clean:
	rm -rf .compared .built acceptance
.PHONY: clean

lib/gherkin/parser.rb: ../gherkin.berp gherkin-ruby.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-ruby.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@
