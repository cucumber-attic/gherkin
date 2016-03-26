GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
PICKLES  = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.pickles.json,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

SRC_FILES= $(shell find src -name "*.[ch]*")

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(ASTS) $(ERRORS) $(PICKLES)
	touch $@

.built: ./include/rule_type.h src/parser.c src/dialect.c $(SRC_FILES) src/Makefile LICENSE
	cd src; $(MAKE)
	touch $@

clean:
	rm -rf .compared .built acceptance ./include/rule_type.h src/parser.c src/dialect.c
	cd src; $(MAKE) $@
.PHONY: clean

libs: ./include/rule_type.h src/parser.c src/dialect.c
	cd src; $(MAKE) $@
.PHONY: libs

./include/rule_type.h: ../gherkin.berp gherkin-c-rule-type.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-c-rule-type.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

src/parser.c: ../gherkin.berp gherkin-c-parser.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-c-parser.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

src/dialect.c: ../gherkin-languages.json dialect.c.jq
	$(MAKE) update-gherkin-languages

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens bin/gherkin_generate_tokens
	mkdir -p `dirname $@`
	bin/gherkin_generate_tokens $< > $@
	diff --unified $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.json: ../testdata/%.feature ../testdata/%.feature.ast.json bin/gherkin_generate_ast
	mkdir -p `dirname $@`
	bin/gherkin_generate_ast $< | jq --sort-keys "." > $@
	diff --unified $<.ast.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.json

acceptance/testdata/%.feature.errors: ../testdata/%.feature ../testdata/%.feature.errors bin/gherkin_generate_ast
	mkdir -p `dirname $@`
	! bin/gherkin_generate_ast $< 2> $@
	diff --unified $<.errors $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.errors

acceptance/testdata/%.feature.pickles.json: ../testdata/%.feature ../testdata/%.feature.pickles.json bin/gherkin_generate_pickles
	mkdir -p `dirname $@`
	bin/gherkin_generate_pickles $< | jq --sort-keys "." > $@
	diff --unified $<.pickles.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.pickles.json

update-gherkin-languages: src/dialect.c.tmp
	diff -q src/dialect.c.tmp src/dialect.c || mv src/dialect.c.tmp src/dialect.c
.PHONY: update-gherkin-languages

src/dialect.c.tmp: ../gherkin-languages.json dialect.c.jq
	cat $< | jq -f dialect.c.jq -r -c > $@
.INTERMEDIATE: src/dialect.c.tmp

LICENSE: ../LICENSE
	cp $< $@
