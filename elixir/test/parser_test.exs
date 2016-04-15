defmodule ParserTest do
  use ExUnit.Case
  doctest Gherkin.Parser

  test "parse" do
    assert Gherkin.Parser.parse() == true
  end
end
