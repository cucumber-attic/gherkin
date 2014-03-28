all: Gherkin/bin/Debug/Gherkin.dll
.PHONY: all

release: Gherkin/bin/Release/Gherkin.dll
.PHONY: release

Gherkin/Parser.cs: ../gherkin.berp gherkin-csharp.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-csharp.razor -o $@

Gherkin/bin/Debug/Gherkin.dll: Gherkin/Parser.cs
	xbuild

Gherkin/bin/Release/Gherkin.dll: Gherkin/Parser.cs
	xbuild /p:Configuration=Release

test: all
	./nunit.sh Gherkin.Specs/bin/Debug/Gherkin.Specs.dll
.PHONY: test

clean:
	rm -rf */bin
	rm -rf */obj
	rm -f Gherkin/Parser.cs
.PHONY: clean
