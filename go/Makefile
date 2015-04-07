GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

GO_SOURCE_FILES = $(shell find . -name "*.go") parser.go dialects_builtin.go

export GOPATH = $(realpath ./)

all: bin/gherkin-generate-tokens bin/gherkin-generate-ast

test: $(TOKENS) $(ASTS) $(ERRORS)
.PHONY: test

.compared: .built $(TOKENS) $(ASTS) $(ERRORS)
	touch $@

.built: $(GO_SOURCE_FILES) bin/gherkin-generate-tokens bin/gherkin-generate-ast
	touch $@

bin/gherkin-generate-tokens: $(GO_SOURCE_FILES)
	go build -o $@ ./gherkin-generate-tokens

bin/gherkin-generate-ast: $(GO_SOURCE_FILES)
	go build -o $@ ./gherkin-generate-ast

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

parser.go: ../gherkin.berp parser.go.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t parser.go.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

dialects_builtin.go: ../dialects.json
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
	rm -rf .compared .built acceptance bin/ parser.go dialects_builtin.go
.PHONY: clean
