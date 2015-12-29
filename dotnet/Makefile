GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

CS_FILES = $(shell find . -type f \( -iname "*.cs" ! -iname "*.NETFramework*" \))
NUNIT = packages/NUnit.Runners.2.6.3/tools/nunit-console.exe

all: .compared
.PHONY: all

.compared: .built $(TOKENS) $(ASTS) $(ERRORS)
	touch $@

.built: .sln_built_debug $(NUNIT) LICENSE
	mono $(NUNIT) -noxml -nologo -stoponerror Gherkin.Specs/bin/Debug/Gherkin.Specs.dll
	touch $@

acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-tokens $< > $@
	diff --unified $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.json: ../testdata/%.feature ../testdata/%.feature.ast.json .built
	mkdir -p `dirname $@`
	bin/gherkin-generate-ast $< | jq --sort-keys "." > $@
	diff --unified $<.ast.json $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.json

acceptance/testdata/%.feature.errors: ../testdata/%.feature ../testdata/%.feature.errors .built
	mkdir -p `dirname $@`
	! bin/gherkin-generate-ast $< > $@
	diff --unified $<.errors $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.errors

clean:
	rm -rf .compared .built acceptance Gherkin/Parser.cs Gherkin/gherkin-languages.json
	rm -rf */bin
	rm -rf */obj
	rm -rf */packages
.PHONY: clean

Gherkin/Parser.cs: ../gherkin.berp gherkin-csharp.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-csharp.razor -o $@

.sln_built_debug: Gherkin/Parser.cs $(CS_FILES) Gherkin/gherkin-languages.json
	rm -f $@
	mono --version
	mono .nuget/NuGet.exe restore Gherkin.CSharp.sln
	xbuild /p:Configuration=Debug
	touch $@

Gherkin/bin/Debug/Gherkin.dll: Gherkin/Parser.cs $(CS_FILES) Gherkin/gherkin-languages.json
	rm -f $@
	xbuild /p:Configuration=Debug
	touch $@

Gherkin/bin/Release/Gherkin.dll: Gherkin/Parser.cs $(CS_FILES) Gherkin/gherkin-languages.json
	rm -f $@
	xbuild /p:Configuration=Release
	touch $@

$(NUNIT):
	mono .nuget/NuGet.exe install NUnit.Runners -Version 2.6.3 -o packages

Gherkin/gherkin-languages.json: ../gherkin-languages.json
	cp $< $@

LICENSE: ../LICENSE
	cp $< $@

update-gherkin-languages: Gherkin/gherkin-languages.json
.PHONY: update-gherkin-languages
