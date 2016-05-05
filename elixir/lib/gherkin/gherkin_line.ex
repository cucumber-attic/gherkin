defmodule Gherkin.GherkinLine do

  defstruct line_number: nil,
            indent: nil,
            line_text: nil,
            trimmed_line_text: nil

  def new(line_text, line_number) do
    trimmed_line_text = String.lstrip(line_text)
    %__MODULE__{
      line_number: line_number,
      line_text: line_text,
      trimmed_line_text: trimmed_line_text,
      indent: String.length(line_text) - String.length(trimmed_line_text)
    }
  end

  def get_line_text(line), do: get_line_text(line, 0)
  def get_line_text(%{indent: indent, trimmed_line_text: trimmed_line_text}, indent_to_remove)
    when indent_to_remove < 0 or indent_to_remove > indent do
      trimmed_line_text
  end
  def get_line_text(%{line_text: line_text}, indent_to_remove) do
    String.slice(line_text, indent_to_remove..-1)
  end

end
