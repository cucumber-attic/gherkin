GOOD_FEATURE_FILES = $(shell find testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find testdata/bad -name "*.feature")

CSHARP_TOKENS = $(patsubst %.feature,%.csharp.tokens,$(GOOD_FEATURE_FILES))
CSHARP_AST    = $(patsubst %.feature,%.csharp.ast,$(GOOD_FEATURE_FILES))

all: csharp java ruby
.PHONY: all

clean:
	rm -f $(CSHARP_TOKENS) $(CSHARP_AST)
.PHONY: clean

### CSHARP

csharp: csharp-tokens-check

csharp-tokens-check: csharp-build $(CSHARP_TOKENS)
	ruby compare.rb csharp

csharp-build:
	cd csharp && make test
.PHONY: csharp-build

%.csharp.tokens: %.feature
	csharp/generate-tokens $< > $@

%.csharp.ast: %.feature
	csharp/generate-ast $< > $@
