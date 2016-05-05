IO.puts "EOF"

parser = Gherkin.Parser.new(Gherkin.TokenFormatterBuilder)

System.argv
|> Enum.each(fn (file) ->
  {:ok, file} = File.open(file)
  IO.puts Gherkin.Parser.parse(parser, file)
end)
