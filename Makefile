GOOD_FEATURE_FILES = $(shell find testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find testdata/bad -name "*.feature")

CSHARP_TOKENS = $(patsubst %.feature,%.csharp.tokens,$(GOOD_FEATURE_FILES))
CSHARP_AST    = $(patsubst %.feature,%.csharp.ast,$(GOOD_FEATURE_FILES))
JAVA_TOKENS   = $(patsubst %.feature,%.java.tokens,$(GOOD_FEATURE_FILES))
JAVA_AST      = $(patsubst %.feature,%.java.ast,$(GOOD_FEATURE_FILES))

all: csharp java
.PHONY: all

clean:
	rm -f $(CSHARP_TOKENS) $(CSHARP_AST) $(JAVA_TOKENS) $(JAVA_AST)
	cd csharp && make test
	cd java && make clean
.PHONY: clean

### CSHARP

csharp: csharp-build $(CSHARP_TOKENS) $(CSHARP_AST)
	ruby compare.rb csharp

csharp-build:
	cd csharp && make test
.PHONY: csharp-build

%.csharp.tokens: %.feature
	csharp/generate-tokens $< > $@

%.csharp.ast: %.feature
	csharp/generate-ast $< > $@

### Java

java: java-build $(JAVA_TOKENS) $(JAVA_AST)
	ruby compare.rb java

java-build:
	cd java && make test
.PHONY: java-build

%.java.tokens: %.feature
	java/generate-tokens $< > $@

%.java.ast: %.feature
	java/generate-ast $< > $@
