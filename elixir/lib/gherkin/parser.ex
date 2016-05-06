defmodule Gherkin.Parser do

  alias Gherkin.{TokenScanner,Token}

  defstruct scanner_state: nil, builder: nil, builder_state: nil

  def new(builder) do
    %__MODULE__{builder: builder}
  end

  def parse(parser, io) do
    initial_state = %{parser | scanner_state: TokenScanner.new, builder_state: call_builder(parser, :new)}
    final_state = parser_loop(initial_state, io)
    #IO.puts "final_state"
    #IO.inspect final_state
    call_builder(parser, :get_result, [final_state.builder_state])
  end
  defp parser_loop(parser_state, io) do
    #IO.inspect(parser)

    {:ok, token, new_scanner_state} = TokenScanner.read(io, parser_state.scanner_state)

    #IO.puts "----------------------------------------"

    #IO.inspect(token)

    matched_token = match_token(parser_state, token)

   # IO.inspect(matched_token)

    new_parser_state = %{parser_state |
      scanner_state: new_scanner_state,
      builder_state: call_builder(parser_state, :build, [parser_state.builder_state, matched_token])
    }


    if Token.eof?(matched_token) do
      #IO.puts "out"
      new_parser_state
    else
      #IO.puts "in"
      parser_loop(new_parser_state, io)
    end
  end

  defp call_builder(%{builder: builder}, fun, args \\ []) do
    Kernel.apply(builder, fun, args)
  end

  def match_token(_parser_state, token = %{line: nil}) do
    token
  end
  def match_token(parser_state, token = %{line: %{trimmed_line_text: trimmed_line_text}}) do
    if String.starts_with?(trimmed_line_text, "Feature:") do
      %{token |
        matched_type: :FeatureLine,
        matched_text: trimmed_line_text |> String.slice(8..-1) |> String.strip,
        matched_keyword: String.slice(trimmed_line_text, 0, 7),
        matched_indent: token.line.indent,
        matched_items: [],
        location: %{token.location | column: token.line.indent + 1},
      }
    else
      token
    end
  end

end
