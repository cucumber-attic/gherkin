GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
AST      = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast,$(GOOD_FEATURE_FILES))

JAVA_FILES = $(shell find . -name "*.java")

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(AST)
	touch $@

.built: src/main/java/gherkin/Parser.java $(JAVA_FILES)
	mvn test
	touch $@

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	java -classpath target/classes:target/test-classes gherkin.GenerateTokens $< > $@
	diff --unified --ignore-all-space $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast: ../testdata/%.feature ../testdata/%.feature.ast .built
	mkdir -p `dirname $@`
	java -classpath target/classes:target/test-classes gherkin.GenerateAst $< > $@
	diff --unified --ignore-all-space $<.ast $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast

clean:
	rm -rf .compared .built acceptance target
.PHONY: clean

src/main/java/gherkin/Parser.java: ../gherkin.berp gherkin-java.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-java.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@
