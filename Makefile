all: test
.PHONY: all

release: Gherkin/bin/Release/Gherkin.dll
.PHONY: release

Gherkin/Parser.cs: ../gherkin.berp gherkin-csharp.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t gherkin-csharp.razor -o $@

Gherkin/bin/Debug/Gherkin.dll: Gherkin/Parser.cs
	xbuild

Gherkin/bin/Release/Gherkin.dll: Gherkin/Parser.cs
	xbuild /p:Configuration=Release

packages/NUnit.Runners.2.6.3/tools/nunit-console.exe:
	mono --runtime=v4.0 .nuget/NuGet.exe install NUnit.Runners -Version 2.6.3 -o packages

test: Gherkin/bin/Debug/Gherkin.dll packages/NUnit.Runners.2.6.3/tools/nunit-console.exe
	mono --runtime=v4.0 packages/NUnit.Runners.2.6.3/tools/nunit-console.exe -noxml -nodots -labels -stoponerror Gherkin.Specs/bin/Debug/Gherkin.Specs.dll
.PHONY: test

clean:
	rm -rf */bin
	rm -rf */obj
	rm -rf */packages
	rm -f Gherkin/Parser.cs
.PHONY: clean
