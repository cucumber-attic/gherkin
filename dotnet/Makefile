SHELL := /usr/bin/env bash
GOOD_FEATURE_FILES = $(shell find ../testdata/good -name "*.feature")
BAD_FEATURE_FILES  = $(shell find ../testdata/bad -name "*.feature")

TOKENS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.tokens,$(GOOD_FEATURE_FILES))
ASTS     = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.ast.ndjson,$(GOOD_FEATURE_FILES))
ERRORS   = $(patsubst ../testdata/%.feature,acceptance/testdata/%.feature.errors.ndjson,$(BAD_FEATURE_FILES))

CS_FILES = $(shell find . -type f \( -iname "*.cs" ! -iname "*.NETFramework*" \))

all: .compared
.PHONY: all

.compared: .sln_built_debug $(TOKENS) $(ASTS) $(ERRORS) 
	touch $@

	
.run_tests:  
	dotnet test Gherkin.Specs 
	touch $@	
	
acceptance/testdata/%.feature.tokens: ../testdata/%.feature ../testdata/%.feature.tokens .sln_built_debug
	mkdir -p `dirname $@`
	
	bin/gherkin-generate-tokens net45 $< > $@
	diff --unified $<.tokens $@

	rm -f $@
	
	bin/gherkin-generate-tokens netcoreapp1.0 $< > $@
	diff --unified $<.tokens $@
	
.DELETE_ON_ERROR: acceptance/testdata/%.feature.tokens

acceptance/testdata/%.feature.ast.ndjson: ../testdata/%.feature ../testdata/%.feature.ast.ndjson .sln_built_debug
	mkdir -p `dirname $@`
	
	bin/gherkin-generate-ast net45 --no-source --no-pickles $< | jq --sort-keys --compact-output "." > $@
	diff --unified <(jq "." $<.ast.ndjson) <(jq "." $@)

	rm -f $@

	bin/gherkin-generate-ast netcoreapp1.0 --no-source --no-pickles $< | jq --sort-keys --compact-output "." > $@
	diff --unified <(jq "." $<.ast.ndjson) <(jq "." $@)

.DELETE_ON_ERROR: acceptance/testdata/%.feature.ast.ndjson

acceptance/testdata/%.feature.errors.ndjson: ../testdata/%.feature ../testdata/%.feature.errors.ndjson .sln_built_debug
	mkdir -p `dirname $@`
	
	bin/gherkin-generate-ast net45 --no-pickles $< | jq --sort-keys --compact-output "." > $@
	diff --unified $<.errors.ndjson $@

	rm -f $@

	bin/gherkin-generate-ast netcoreapp1.0 --no-pickles $< | jq --sort-keys --compact-output "." > $@
	diff --unified $<.errors.ndjson $@

.DELETE_ON_ERROR: acceptance/testdata/%.feature.errors.ndjson


clean:
	rm -rf .compared .built acceptance Gherkin/Parser.cs Gherkin/gherkin-languages.json
	rm -rf */bin
	rm -rf */obj
	rm -rf */packages
	rm -rf ./output
.PHONY: clean

Gherkin/Parser.cs: ../gherkin.berp gherkin-csharp.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-csharp.razor -o $@

.sln_built_debug: Gherkin/Parser.cs $(CS_FILES) Gherkin/gherkin-languages.json
	rm -f $@

	dotnet --version
	dotnet restore

	dotnet build Gherkin
	dotnet build Gherkin.CLI
	dotnet build Gherkin.TokensGenerator
	dotnet build Gherkin.Specs

	dotnet publish -o output/net45 -f net45 Gherkin.CLI/
	dotnet publish -o output/netcoreapp1.0 -f netcoreapp1.0 Gherkin.CLI/
	
	dotnet publish -o output/net45 -f net45 Gherkin.TokensGenerator/
	dotnet publish -o output/netcoreapp1.0 -f netcoreapp1.0 Gherkin.TokensGenerator/

	touch $@

Gherkin/gherkin-languages.json: ../gherkin-languages.json
	cp $< $@

LICENSE: ../LICENSE
	cp $< $@

update-gherkin-languages: Gherkin/gherkin-languages.json
.PHONY: update-gherkin-languages

update-version: Gherkin/project.json.tmp Gherkin/project.json
	diff -q $< Gherkin/project.json || mv $< Gherkin/project.json
.PHONY: update-version

Gherkin/project.json.tmp: Gherkin/project.json ../VERSION
	sed "s/\(\"version\" *: *\"\)[0-9]*\.[0-9]*\.[0-9]*-\*\(\"\)/\1`cat ../VERSION`\2/" $< > $@
.INTERMEDIATE: Gherkin/project.json.tmp
