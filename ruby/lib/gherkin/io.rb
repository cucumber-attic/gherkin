require 'json'
require 'gherkin/parser'
require 'gherkin/pickles/compiler'

module Gherkin
  class IO
    def initialize(print_source, print_ast, print_pickles)
      @print_source, @print_ast, @print_pickles = print_source, print_ast, print_pickles
      @parser = Gherkin::Parser.new
      @compiler = Gherkin::Pickles::Compiler.new
    end

    def process(input, output)
      input.each_line do |line|
        event = JSON.parse(line)
        if (event['type'] == 'source')
          uri = event['uri']
          source = event['data']
          begin
            gherkin_document = @parser.parse(source)

            if (@print_source)
              output.puts(line)
            end
            if (@print_ast)
              output.puts(gherkin_document.to_json)
            end
            if (@print_pickles)
              pickles = @compiler.compile(gherkin_document, uri)
              pickles.each do |pickle|
                output.puts(pickle.to_json)
              end
            end
          rescue Gherkin::CompositeParserException => e
            print_errors(output, e.errors, uri)
          rescue Gherkin::ParserError => e
            print_errors(output, [e], uri)
          end
        else
        end
      end
    end

    def print_errors(output, errors, uri)
      errors.each do |error|
        output.puts(JSON.generate({
          type: "attachment",
          source: {
            uri: uri,
            start: {
              line: error.location[:line],
              column: error.location[:column]
            }
          },
          data: error.message,
          media: {
            encoding: "utf-8",
            type: "text/vnd.cucumber.stacktrace+plain"
          }
        }))
      end
    end
  end
end
