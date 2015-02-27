GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
AST      = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast,$(GOOD_FEATURE_FILES))

RUBY_FILES = $(shell find . -name "*.rb")

all: .compared
.PHONY: all

.compared: .built $(TOKENS)
	touch $@

.built: lib/gherkin/parser.js $(RUBY_FILES)
	./node_modules/.bin/mocha
	touch $@

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	node bin/gherkin-generate-tokens $< > $@
	diff --unified --ignore-all-space $<.tokens $@ || rm $@

acceptance/testdata/%.feature.ast: ../testdata/%.feature ../testdata/%.feature.ast .built
	mkdir -p `dirname $@`
	node bin/gherkin-generate-ast $< > $@
	diff --unified --ignore-all-space $<.ast $@ || rm $@

clean:
	rm -rf .compared .built acceptance
.PHONY: clean

lib/gherkin/parser.js: ../gherkin.berp gherkin-javascript.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-javascript.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@
