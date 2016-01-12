require_relative '../dialect'

module Gherkin
  module Pickles
    class Compiler
      def compile(feature, path)
        pickles = []
        dialect = Dialect.for(feature[:language])

        feature_tags = feature[:tags]
        background_steps = get_background_steps(feature[:background], path)

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
          steps.push(pickle_step(step, path))
        end

        pickle = {
          tags: pickle_tags(tags, path),
          name: scenario[:keyword] + ": " + scenario[:name],
          locations: [pickle_location(scenario[:location], path)],
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
              arguments = create_pickle_arguments(scenario_outline_step[:argument], variable_cells, value_cells, path)
              pickle_step = {
                text: step_text,
                arguments: arguments,
                locations: [
                  pickle_location(values[:location], path),
                  pickle_step_location(scenario_outline_step, path)
                ]
              }
              steps.push(pickle_step)
            end

            pickle = {
              name: keyword + ": " + interpolate(scenario_outline[:name], variable_cells, value_cells),
              steps: steps,
              tags: pickle_tags(tags, path),
              locations: [
                pickle_location(values[:location], path),
                pickle_location(scenario_outline[:location], path)
              ]
            }
            pickles.push(pickle);

          end
        end
      end

      def create_pickle_arguments(argument, variable_cells, value_cells, path)
        result = []
        return result if argument.nil?
        if (argument[:type] == :DataTable)
          table = {
            rows: argument[:rows].map do |row|
              {
                cells: row[:cells].map do |cell|
                  {
                    location: pickle_location(cell[:location], path),
                    value: interpolate(cell[:value], variable_cells, value_cells)
                  }
                end
              }
            end
          }
          result.push(table)
        elsif (argument[:type] == :DocString)
          doc_string = {
            location: pickle_location(argument[:location], path),
            content: interpolate(argument[:content], variable_cells, value_cells)
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

      def get_background_steps(background, path)
        if(background)
          background[:steps].map do |step|
            pickle_step(step, path)
          end
        else
          []
        end
      end

      def pickle_step(step, path)
        {
          text: step[:text],
          arguments: create_pickle_arguments(step[:argument], [], [], path),
          locations: [pickle_step_location(step, path)]
        }
      end

      def pickle_step_location(step, path)
        {
          path: path,
          line: step[:location][:line],
          column: step[:location][:column] + (step[:keyword] ? step[:keyword].length : 0)
        }
      end

      def pickle_location(location, path)
        {
          path: path,
          line: location[:line],
          column: location[:column]
        }
      end

      def pickle_tags(tags, path)
        tags.map {|tag| pickle_tag(tag, path)}
      end

      def pickle_tag(tag, path)
        {
          name: tag[:name],
          location: pickle_location(tag[:location], path)
        }
      end
    end
  end
end
