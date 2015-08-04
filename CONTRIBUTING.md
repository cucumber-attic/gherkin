Please read [CONTRIBUTING](https://github.com/cucumber/gherkin3/blob/master/CONTRIBUTING.md) first.
You should clone the [cucumber/gherkin3](https://github.com/cucumber/gherkin3) repo if you want
to contribute.

## OS X/Linux

Just run `make` from this directory.

## Windows

Open `Gherkin.CSharp.sln` from this directory in Visual Studio 2013 and build.

Alternatively, run `msbuild` from this directory.

Keep in mind that this will only run unit tests. The acceptance tests are only
run when you build with `make`.

## Make a release


    # Change version in `Gherkin.NuGetPackages\Gherkin.nuspec`
    .nuget\NuGet.exe pack Gherkin.NuGetPackages\Gherkin.nuspec