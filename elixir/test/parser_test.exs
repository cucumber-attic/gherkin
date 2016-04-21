defmodule ParserTest do
  use ExUnit.Case
  doctest Gherkin.Parser

  test "parse" do
    assert Gherkin.Parser.parse() == %Gherkin.Node.GherkinDocument{
      type: "GherkinDocument",
      feature: %Gherkin.Node.Feature{
        type: "Feature",
        tags: [],
        # location: { line: 1, column: 1 },
        # language: 'en',
        # keyword: 'Feature',
        # name: 'hello',
        # description: undefined,
        # children: []
      },
      comments: []
    }
  end
end
