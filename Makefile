GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))

JAVA_FILES = $(shell find . -name "*.java")

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(ASTS)
	touch $@

.built: src/main/java/gherkin/Parser.java $(JAVA_FILES)
	mvn test
	touch $@

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	java -classpath target/classes gherkin.GenerateTokens $< > $@
	diff --unified --ignore-all-space $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.json: ../testdata/%.feature ../testdata/%.feature.ast.json .built
	mkdir -p `dirname $@`
	java \
	    -javaagent:jacoco/jacocoagent.jar=destfile=target/jacoco.exec \
	    -classpath ~/.m2/repository/info/cukes/gherkin-jvm-deps/1.0.2/gherkin-jvm-deps-1.0.2.jar:target/classes \
	    gherkin.GenerateAst $< | jq --sort-keys "." > $@
	diff --unified --ignore-all-space $<.ast.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.json

clean:
	rm -rf .compared .built acceptance target
.PHONY: clean

src/main/java/gherkin/Parser.java: ../gherkin.berp gherkin-java.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-java.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@
