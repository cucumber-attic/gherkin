GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
PICKLES  = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.pickles.json,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

JAVASCRIPT_FILES = $(shell find lib -name "*.js") index.js

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(ASTS) $(PICKLES) $(ERRORS)
	touch $@

.built: lib/gherkin/parser.js lib/gherkin/gherkin-languages.json $(JAVASCRIPT_FILES) dist/gherkin.js dist/gherkin.min.js node_modules/.fetched LICENSE
	./node_modules/.bin/mocha
	touch $@

node_modules/.fetched: package.json
	npm install
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

# acceptance/testdata/%.feature.pickles.json: ../testdata/%.feature .built
# 	mkdir -p `dirname $@`
# 	bin/gherkin-generate-pickles $< | jq --sort-keys "." > $<.pickles.json
# .DELETE_ON_ERROR: ../testdata/%.feature.pickles.json

acceptance/testdata/%.feature.pickles.json: ../testdata/%.feature ../testdata/%.feature.pickles.json .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-pickles $< | jq --sort-keys "." > $@
	diff --unified $<.pickles.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.pickles.json

acceptance/testdata/%.feature.errors: ../testdata/%.feature ../testdata/%.feature.errors .built
	mkdir -p `dirname $@`
	! bin/gherkin-generate-ast $< 2> $@
	diff --unified $<.errors $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.errors

lib/gherkin/parser.js: ../gherkin.berp gherkin-javascript.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-javascript.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

lib/gherkin/gherkin-languages.json: ../gherkin-languages.json
	cp $^ $@

dist/gherkin.js: lib/gherkin/parser.js LICENSE node_modules/.fetched
	mkdir -p `dirname $@`
	echo '/*' > $@
	cat LICENSE >> $@
	echo '*/' >> $@
	./node_modules/.bin/browserify index.js >> $@

dist/gherkin.min.js: dist/gherkin.js node_modules/.fetched
	mkdir -p `dirname $@`
	echo '/*' > $@
	cat LICENSE >> $@
	echo '*/' >> $@
	./node_modules/.bin/uglifyjs $^ >> $@

LICENSE: ../LICENSE
	cp $< $@

clean:
	rm -rf .compared .built acceptance lib/gherkin/parser.js lib/gherkin/gherkin-languages.json dist
.PHONY: clean

update-gherkin-languages: lib/gherkin/gherkin-languages.json
.PHONY: update-gherkin-languages
