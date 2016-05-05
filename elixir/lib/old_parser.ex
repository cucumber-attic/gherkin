# This file is generated. Do not edit! Edit /elixir/parser.elixir.razor instead.

defmodule Gherkin do
  defmodule Node do
    defmodule GherkinDocument do
      defstruct type: "GherkinDocument", feature: nil, comments: []
    end

    defmodule Feature do
      defstruct type: "Feature", tags: []
    end
  end

  # defmodule Parser do
  #   def parse do
  #     %Node.GherkinDocument{
  #       feature: %Node.Feature{}
  #     }
  #   end
  # end
end
