GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))

JAVASCRIPT_FILES = $(shell find . -name "*.js")

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(ASTS)
	touch $@

.built: lib/gherkin/parser.js lib/gherkin/dialects.json $(JAVASCRIPT_FILES) node_modules
	./node_modules/.bin/mocha
	touch $@

node_modules: package.json
	npm install

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-tokens $< > $@
	diff --unified --ignore-all-space $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.json: ../testdata/%.feature ../testdata/%.feature.ast.json .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-ast $< | jq --sort-keys "." > $@
	diff --unified --ignore-all-space $<.ast.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.json

lib/gherkin/parser.js: ../gherkin.berp gherkin-javascript.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-javascript.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

lib/gherkin/dialects.json: ../dialects.json
	cp $^ $@

clean:
	rm -rf .compared .built acceptance lib/gherkin/parser.js lib/gherkin/dialects.json
.PHONY: clean
