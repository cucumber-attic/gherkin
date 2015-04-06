GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

GO_SOURCE_FILES = $(shell find . -name "*.go")

export GOPATH = $(realpath ./)

all: bin/gherkin-generate-tokens bin/gherkin-generate-ast

test: $(TOKENS) $(ASTS) $(ERRORS)
.PHONY: test

.compared: .built $(TOKENS) $(ASTS) $(ERRORS)
	touch $@

.built: $(GO_SOURCE_FILES) src/github.com/cucumber/go-gherkin3/parser.go src/github.com/cucumber/go-gherkin3/dialects_builtin.go bin/gherkin-generate-tokens bin/gherkin-generate-ast
	touch $@

bin/gherkin-generate-tokens:
	go install github.com/cucumber/go-gherkin3/gherkin-generate-tokens

bin/gherkin-generate-ast:
	go install github.com/cucumber/go-gherkin3/gherkin-generate-ast

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens
	mkdir -p `dirname $@`
	bin/gherkin-generate-tokens $< > $@
	diff --unified $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.json: ../testdata/%.feature ../testdata/%.feature.ast.json
	mkdir -p `dirname $@`
	bin/gherkin-generate-ast $< | jq --sort-keys "." > $@
	diff --unified $<.ast.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.json

acceptance/testdata/%.feature.errors: ../testdata/%.feature ../testdata/%.feature.errors
	mkdir -p `dirname $@`
	! bin/gherkin-generate-ast $< 2> $@
	diff --unified $<.errors $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.errors

src/github.com/cucumber/go-gherkin3/parser.go: ../gherkin.berp gherkin-golang.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-golang.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

src/github.com/cucumber/go-gherkin3/dialects_builtin.go: ../dialects.json
	cat $^ | jq '. as $$root | ([to_entries[] | [ \
	  "\t",(.key|@json),": &GherkinDialect{\n", \
	  "\t\t", (.key|@json),", ", (.value.name|@json),", ", (.value.native|@json), \
	  ", map[string][]string{\n"] + ( \
	    [.value|{"feature","background","scenario","scenarioOutline","examples","given","when","then","and","but"} \
	    |to_entries[]| "\t\t\t"+(.key|@json), ": []string{\n", ([ .value[] | "\t\t\t\t", @json, ",\n"  ]|add),"\t\t\t},\n" ]\
	    ) + ["\t\t},\n","\t},\n"] | add ] \
	  | add) | "package gherkin3\n\n" \
	  + "// Builtin dialects for " + ([ $$root | to_entries[] | .key+" ("+.value.name+")" ] | join(", ")) + "\n" \
	  + "func GherkinDialectsBuildin() GherkinDialectProvider {\n" \
	  + "\treturn buildinDialects\n" \
	  + "}\n\n" \
	  + "var buildinDialects GherkinDialectProvider = gherkinDialectMap{\n" \
	  + . + "}\n"' -r -c > $@

clean:
	rm -rf .compared .built acceptance bin/ src/github.com/cucumber/go-gherkin3/parser.go src/github.com/cucumber/go-gherkin3/dialects_builtin.go
.PHONY: clean


push-release:
	- git remote add go-split git@github.com:cucumber/go-gherkin3.git
	cd ../ && git subtree push --prefix=golang/src/github.com/cucumber/go-gherkin3 --squash go-split master

.PHONY: push-release
