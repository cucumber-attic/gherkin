defmodule Gherkin.TokenScanner do

  alias Gherkin.{GherkinLine,Token}

  defmodule State do
    defstruct line_number: 0
  end

  def new do
    %State{}
  end

  def read(io, state = %{line_number: line_number}) do

    current_line_number = line_number + 1
    new_state = %{state | line_number: current_line_number}
    location = %{line: current_line_number, column: 0}

    case IO.gets(io, nil) do
      {:error, reason} ->
        {:error, reason, new_state}
      :eof ->
        {:ok, Token.new(location), new_state}
      line ->
        token =
          line
          |> GherkinLine.new(current_line_number)
          |> Token.new(location)
        {:ok, token, new_state}
    end
  end

end
