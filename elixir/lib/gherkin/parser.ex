defmodule Gherkin.Parser do

  alias Gherkin.{TokenScanner,Token}

  defstruct scanner_state: nil, builder: nil, builder_state: nil

  def new(builder) do
    %__MODULE__{builder: builder}
  end

  def parse(parser, io) do
    initial_state = %{parser | scanner_state: TokenScanner.new, builder_state: call_builder(parser, :new)}
    final_state = do_parse(initial_state, io)
    IO.puts "final_state"
    IO.inspect final_state
    call_builder(parser, :get_result, [final_state.builder_state])
  end
  defp do_parse(parser, io) do
    IO.inspect(parser)
    {:ok, token, new_scanner_state} = TokenScanner.read(io, parser.scanner_state)
    new_parser_state = %{parser |
      scanner_state: new_scanner_state,
      builder_state: call_builder(parser, :build, [parser.builder_state, token])
    }
    IO.inspect(token)
    if Token.eof?(token) do
      IO.puts "out"
      new_parser_state
    else
      IO.puts "in"
      do_parse(new_parser_state, io)
    end
  end

  defp call_builder(%{builder: builder}, fun, args \\ []) do
    Kernel.apply(builder, fun, args)
  end
end
