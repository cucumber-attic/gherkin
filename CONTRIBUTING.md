

## Adding good testdata

1) Add a `.feature` file to `testdata/good`
2) Generate the tokens:

    # For example
    ruby ruby/bin/gherkin-generate-tokens \
    testdata/good/newfile.feature > \
    testdata/good/newfile.feature.tokens

3) Inspect the generated `.feature.tokens` file manually to see if it's good.
4) Generate the tokens:

    # For example
    ruby ruby/bin/gherkin-generate-tokens \
    testdata/good/newfile.feature | \
    jq --sort-keys "." > \
    testdata/good/newfile.feature.tokens

5) Inspect the generated `.feature.ast.json` file manually to see if it's good.
6) Run `make` from the root directory to verify that all parsers parse it ok.
