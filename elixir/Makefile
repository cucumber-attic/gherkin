GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))

test: lib/parser.ex
	mix test
.PHONY: test

empty: $(TOKENS)
.PHONY: empty

lib/parser.ex: ../gherkin.berp parser.elixir.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t parser.elixir.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-tokens $< > $@
	diff --unified $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

clean:
	rm -rf lib/parser.ex
.PHONY: clean

