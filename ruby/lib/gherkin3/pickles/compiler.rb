require_relative '../dialect'

module Gherkin3
  module Pickles
    class Compiler
      def compile(feature, path)
        pickles = []
        dialect = Dialect.for(feature[:language])

        feature_tags = feature[:tags]
        background_steps = get_background_steps(feature[:background])

        feature[:scenarioDefinitions].each do |scenario_definition|
          if(scenario_definition[:type] == :Scenario)
            compile_scenario(feature_tags, background_steps, scenario_definition, dialect, path, pickles)
          else
            compile_scenario_outline(feature_tags, background_steps, scenario_definition, dialect, path, pickles)
          end
        end
        return pickles
      end

    private

      def compile_scenario(feature_tags, background_steps, scenario, dialect, path, pickles)
        steps = [].concat(background_steps)

        tags = [].concat(feature_tags).concat(scenario[:tags])

        scenario[:steps].each do |step|
          steps.push(pickle_step(step))
        end

        pickle = {
          path: path,
          tags: pickle_tags(tags),
          name: scenario[:keyword] + ": " + scenario[:name],
          locations: [pickle_location(scenario[:location])],
          steps: steps
        }
        pickles.push(pickle)
      end

      def compile_scenario_outline(feature_tags, background_steps, scenario_outline, dialect, path, pickles)
        keyword = dialect.scenario_keywords[0]
        scenario_outline[:examples].each do |examples|
          variable_cells = examples[:tableHeader][:cells]
          examples[:tableBody].each do |values|
            value_cells = values[:cells]
            steps = [].concat(background_steps)
            tags = [].concat(feature_tags).concat(scenario_outline[:tags]).concat(examples[:tags])

            scenario_outline[:steps].each do |scenario_outline_step|
              step_text = interpolate(scenario_outline_step[:text], variable_cells, value_cells);
              arguments = create_pickle_arguments(scenario_outline_step[:argument], variable_cells, value_cells)
              pickle_step = {
                text: step_text,
                arguments: arguments,
                locations: [
                  pickle_location(values[:location]),
                  pickle_location(scenario_outline_step[:location])
                ]
              }
              steps.push(pickle_step)
            end

            pickle = {
              path: path,
              name: keyword + ": " + interpolate(scenario_outline[:name], variable_cells, value_cells),
              steps: steps,
              tags: pickle_tags(tags),
              locations: [
                pickle_location(values[:location]),
                pickle_location(scenario_outline[:location])
              ]
            }
            pickles.push(pickle);

          end
        end
      end

      def create_pickle_arguments(argument, variables, values)
        result = []
        return result if argument.nil?
        if (argument[:type] == :DataTable)
          table = {
            rows: argument[:rows].map do |row|
              {
                cells: row[:cells].map do |cell|
                  {
                    location: pickle_location(cell[:location]),
                    value: interpolate(cell[:value], variables, values)
                  }
                end
              }
            end
          }
          result.push(table)
        elsif (argument[:type] == :DocString)
          doc_string = {
            location: pickle_location(argument[:location]),
            content: interpolate(argument[:content], variables, values)
          }
          result.push(doc_string)
        else
          raise 'Internal error'
        end
        result
      end

      def interpolate(name, variable_cells, value_cells)
        variable_cells.each_with_index do |variable_cell, n|
          value_cell = value_cells[n]
          name = name.gsub('<' + variable_cell[:value] + '>', value_cell[:value])
        end
        name
      end

      def get_background_steps(background)
        if(background)
          background[:steps].map do |step|
            pickle_step(step)
          end
        else
          []
        end
      end

      def pickle_step(step)
        {
          text: step[:text],
          arguments: create_pickle_arguments(step[:argument], [], []),
          locations: [pickle_location(step[:location])]
        }
      end

      def pickle_location(location)
        {
          line: location[:line],
          column: location[:column]
        }
      end

      def pickle_tags(tags)
        tags.map {|tag| pickle_tag(tag)}
      end

      def pickle_tag(tag)
        {
          name: tag[:name],
          location: pickle_location(tag[:location])
        }
      end
    end
  end
end
