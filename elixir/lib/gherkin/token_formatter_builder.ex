defmodule Gherkin.TokenFormatterBuilder do

  def new do
    %{tokens_text: []}
  end

  def reset(builder), do: new

  def start_rule(builder, _), do: builder

  def end_rule(builder, _), do: builder

  def build(builder = %{tokens_text: tokens_text}, token) do
    %{builder | tokens_text: [format_token(token)|tokens_text]}
  end

  def get_result(%{tokens_text: tokens_text}) do
    tokens_text
    |> Enum.reverse
    |> Enum.join("\n")
  end

  defp format_token(%{line: nil}), do: "EOF"
  defp format_token(token) do
    location = "(#{token.location.line}:#{token.location.column})"
    "#{location}#{token.matched_type}:#{token.matched_keyword}/#{token.matched_text}/#{matched_items(token)}"
  end

  defp matched_items(%{matched_items: nil}), do: ""
  defp matched_items(%{matched_items: items}) do
    items
    |> Enum.map(fn (%{column: c, text: t}) -> "#{c}:#{t}" end)
    |> Enum.join(",")
  end

end
