all: test
.PHONY: all

test: src/main/java/gherkin/Parser.java
	mvn test
.PHONY: test

clean:
	mvn clean
.PHONY: clean

src/main/java/gherkin/Parser.java: ../gherkin.berp gherkin-java.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-java.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@
