GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS       = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
PICKLES    = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.pickles.json,$(GOOD_FEATURE_FILES))
ERRORS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

JAVA_FILES = $(shell find . -name "*.java")

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(ASTS) $(PICKLES) $(ERRORS)
	touch $@

.built: show-version-info src/main/java/gherkin/Parser.java src/main/resources/gherkin/gherkin-languages.json $(JAVA_FILES) LICENSE
	mvn test
	touch $@

show-version-info:
	java -version
.PHONY: show-version-info

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

src/main/java/gherkin/Parser.java: ../gherkin.berp gherkin-java.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-java.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

src/main/resources/gherkin/gherkin-languages.json: ../gherkin-languages.json
	mkdir -p `dirname $@`
	cp $^ $@

LICENSE: ../LICENSE
	cp $< $@

clean:
	rm -rf .compared .built acceptance target src/main/resources/gherkin/gherkin-languages.json
.PHONY: clean

update-gherkin-languages: src/main/resources/gherkin/gherkin-languages.json
.PHONY: update-gherkin-languages
