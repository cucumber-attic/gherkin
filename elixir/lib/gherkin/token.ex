defmodule Gherkin.Token do

  alias Gherkin.GherkinLine

  defstruct line: nil,
            location: nil,
            matched_type: nil,
            matched_text: nil,
            matched_keyword: nil,
            matched_indent: nil,
            matched_items: nil,
            matched_gherkin_dialect: nil

  def new(location) do
    %__MODULE__{location: location}
  end

  def new(line, location) do
    %__MODULE__{line: line, location: location}
  end

  def eof?(%{line: nil}), do: true
  def eof?(_), do: false

  def detach do
    # TODO: detach line - is this needed?
  end

  def token_value(%{line: nil}), do: "EOF"
  def token_value(%{line: line}), do: GherkinLine.get_line_text(line, -1)

end
