GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.json,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors,$(BAD_FEATURE_FILES))

CS_FILES = $(shell find . -type f \( -iname "*.cs" ! -iname "*.NETFramework*" \))

all: .compared
.PHONY: all

.compared: LICENSE .sln_built_debug .run_tests $(TOKENS) $(ASTS) $(ERRORS) 
	touch $@

	
.run_tests:  
	cd Gherkin.Specs
	dotnet test 
	cd ..
	touch $@	
	
acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens 
	mkdir -p `dirname $@`
	
	bin/gherkin-generate-tokens net45 $< | tail -n +19 > $@
	diff --unified $<.tokens $@
	rm -f $@
	
	bin/gherkin-generate-tokens netcoreapp1.0 $< | tail -n +19 > $@
	diff --unified $<.tokens $@
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.json: ../testdata/%.feature ../testdata/%.feature.ast.json
	mkdir -p `dirname $@`
	
	bin/gherkin-generate-ast net45 $< | tail -n +19 | jq --sort-keys "." > $@
	diff --unified $<.ast.json $@
	rm -f $@
	
	bin/gherkin-generate-ast netcoreapp1.0 $< | tail -n +19 | jq --sort-keys "." > $@
	diff --unified $<.ast.json $@
	
.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.json

acceptance/testdata/%.feature.errors: ../testdata/%.feature ../testdata/%.feature.errors
	mkdir -p `dirname $@`
	
	bin/gherkin-generate-ast net45 $< | tail -n +19 > $@
	diff --unified $<.errors $@
	rm -f $@
	
	bin/gherkin-generate-ast netcoreapp1.0 $< | tail -n +19 > $@
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

	dotnet --version
	dotnet restore

	dotnet build Gherkin
	dotnet build Gherkin.AstGenerator
	dotnet build Gherkin.TokensGenerator
	dotnet build Gherkin.Specs
	
	touch $@

Gherkin/gherkin-languages.json: ../gherkin-languages.json
	cp $< $@

LICENSE: ../LICENSE
	cp $< $@

update-gherkin-languages: Gherkin/gherkin-languages.json
.PHONY: update-gherkin-languages

update-version: Gherkin.NuGetPackages/Gherkin.nuspec.tmp Gherkin.NuGetPackages/Gherkin.nuspec
	diff -q $< Gherkin.NuGetPackages/Gherkin.nuspec || mv $< Gherkin.NuGetPackages/Gherkin.nuspec
.PHONY: update-version

Gherkin.NuGetPackages/Gherkin.nuspec.tmp: Gherkin.NuGetPackages/Gherkin.nuspec ../VERSION
	sed "s#\(<version>\).*\(</version>\)#\1`cat ../VERSION`\2#" $< > $@
.INTERMEDIATE: Gherkin.NuGetPackages/Gherkin.nuspec.tmp
