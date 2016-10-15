GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.ndjson,$(GOOD_FEATURE_FILES))
PICKLES  = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.pickles.ndjson,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors.ndjson,$(BAD_FEATURE_FILES))

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

acceptance/testdata/%.feature.ast.ndjson: ../testdata/%.feature ../testdata/%.feature.ast.ndjson .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-ast $< | jq --sort-keys --compact-output "." > $@
	diff --unified $<.ast.ndjson $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.ndjson

acceptance/testdata/%.feature.pickles.ndjson: ../testdata/%.feature ../testdata/%.feature.pickles.ndjson .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-pickles $< | jq --sort-keys --compact-output "." > $@
	diff --unified $<.pickles.ndjson $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.pickles.ndjson

acceptance/testdata/%.feature.errors.ndjson: ../testdata/%.feature ../testdata/%.feature.errors.ndjson .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-ast $< | jq --sort-keys --compact-output "." > $@
	diff --unified $<.errors.ndjson $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.errors.ndjson

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

update-version: gherkin.gemspec.tmp gherkin.gemspec
	diff -q $< gherkin.gemspec || mv $< gherkin.gemspec
.PHONY: update-version

gherkin.gemspec.tmp: gherkin.gemspec ../VERSION
	sed "s/\(s\.version *= *'\)[0-9]*\.[0-9]*\.[0-9]*\('\)/\1`cat ../VERSION`\2/" $< > $@
.INTERMEDIATE: gherkin.gemspec.tmp
