GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
PICKLES  = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.pickles.json,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

RUBY_FILES = $(shell find . -name "*.rb")

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(ASTS) $(PICKLES) $(ERRORS)
	touch $@

.built: lib/gherkin/parser.rb lib/gherkin/gherkin-languages.json $(RUBY_FILES) Gemfile.lock LICENSE
	bundle exec rspec --color
	touch $@

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-tokens $< > $@
	diff --unified $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.json: ../testdata/%.feature ../testdata/%.feature.ast.json .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-ast $< | jq --sort-keys "." > $@
	diff --unified $<.ast.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.json

acceptance/testdata/%.feature.pickles.json: ../testdata/%.feature ../testdata/%.feature.pickles.json .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-pickles $< | jq --sort-keys "." > $@
	diff --unified $<.pickles.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.pickles.json

acceptance/testdata/%.feature.errors: ../testdata/%.feature ../testdata/%.feature.errors .built
	mkdir -p `dirname $@`
	# Travis disables C extensions for jruby, and it doesn't seem possible to
	# tell JRuby *not* to print this warning when they're disabled.
	# Filter out the warning before doing the comparison.
	! bin/gherkin-generate-ast $< 2> $@.tmp
	cat $@.tmp | grep -v "jruby: warning: unknown property jruby.cext.enabled" > $@
	diff --unified $<.errors $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.errors

lib/gherkin/gherkin-languages.json: ../gherkin-languages.json
	cp $^ $@

clean:
	rm -rf .compared .built acceptance lib/gherkin/parser.rb lib/gherkin/gherkin-languages.json coverage
.PHONY: clean

lib/gherkin/parser.rb: ../gherkin.berp gherkin-ruby.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-ruby.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

Gemfile.lock: Gemfile
	bundle install

LICENSE: ../LICENSE
	cp $< $@

update-gherkin-languages: lib/gherkin/gherkin-languages.json
.PHONY: update-gherkin-languages
