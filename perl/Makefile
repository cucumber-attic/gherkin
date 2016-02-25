GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
PICKLES  = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.pickles.json,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

PERL_FILES = $(shell find . -name "*.pm")

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(ASTS) $(PICKLES) $(ERRORS)
	touch $@

.cpanfile_dependencies:
	cpanm --installdeps .
	touch $@

.built: .cpanfile_dependencies lib/Gherkin/Generated/Parser.pm lib/Gherkin/Generated/Languages.pm $(PERL_FILES) bin/gherkin-generate-tokens bin/gherkin-generate-ast
	@$(MAKE) --no-print-directory show-version-info
	# add Perl-level unit tests
	touch $@

show-version-info:
	perl --version
.PHONY: show-version-info

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-tokens $< > $@
	diff --unified $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.json: ../testdata/%.feature ../testdata/%.feature.ast.json .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-ast $< > $@
	diff --unified $<.ast.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.json

acceptance/testdata/%.feature.pickles.json: ../testdata/%.feature ../testdata/%.feature.pickles.json .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-pickles $< > $@
	diff --unified $<.pickles.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.pickles.json

acceptance/testdata/%.feature.errors: ../testdata/%.feature ../testdata/%.feature.errors .built
	mkdir -p `dirname $@`
	! bin/gherkin-generate-ast $< 2> $@
	diff --unified $<.errors $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.errors

# Get to a point where dzil can be run
predistribution: .compared CHANGES LICENSE.txt
	cp ../testdata/good/*.feature acceptance/testdata/good/
	cp ../testdata/bad/*.feature acceptance/testdata/bad/
	cpanm --installdeps --with-develop .
	dzil clean
	@(git status --porcelain 2>/dev/null | grep "^??" | perl -ne\
	    'die "The `release` target includes all files in the working directory. Please remove [$$_], or add it to .gitignore if it should be included\n" if s!.+ perl/(.+?)\n!$$1!')

distribution: predistribution
	dzil test --release && dzil build

release: predistribution
	dzil release

clean:
	rm -rf CHANGES LICENSE.txt Gherkin-* .compared .cpanfile_dependencies .built acceptance lib/Gherkin/Generated
.PHONY: clean

CHANGES:
	cp ../CHANGELOG.md $@

lib/Gherkin/Generated:
	mkdir -p $@

lib/Gherkin/Generated/Languages.pm: lib/Gherkin/Generated
	perl helper-scripts/build_languages.pl < ../gherkin-languages.json > $@

lib/Gherkin/Generated/Parser.pm: ../gherkin.berp gherkin-perl.razor ../bin/berp.exe lib/Gherkin/Generated
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-perl.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

LICENSE.txt: ../LICENSE
	cp $< $@

update-gherkin-languages: gherkin/gherkin-languages.json
.PHONY: update-gherkin-languages
