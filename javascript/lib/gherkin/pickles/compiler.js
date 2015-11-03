var dialects = require('../gherkin-languages.json');

function Compiler() {
  this.compile = function (feature, path) {
    var pickles = [];
    var dialect = dialects[feature.language];

    var featureTags = feature.tags;
    var backgroundSteps = getBackgroundSteps(feature.background);

    feature.scenarioDefinitions.forEach(function (scenarioDefinition) {
      if(scenarioDefinition.type === 'Scenario') {
        compileScenario(featureTags, backgroundSteps, scenarioDefinition, dialect, path, pickles);
      } else {
        compileScenarioOutline(featureTags, backgroundSteps, scenarioDefinition, dialect, path, pickles);
      }
    });
    return pickles;
  };

  function compileScenario(featureTags, backgroundSteps, scenario, dialect, path, pickles) {
    var steps = [].concat(backgroundSteps);

    var tags = [].concat(featureTags).concat(scenario.tags);

    scenario.steps.forEach(function (step) {
      steps.push(pickleStep(step));
    });

    var pickle = {
      path: path,
      tags: pickleTags(tags),
      keyword: scenario.keyword,
      name: scenario.name,
      locations: [pickleLocation(scenario.location)],
      steps: steps
    };
    pickles.push(pickle);
  }

  function compileScenarioOutline(featureTags, backgroundSteps, scenarioOutline, dialect, path, pickles) {
    var keyword = dialect.scenario[0];
    scenarioOutline.examples.forEach(function (examples) {
      var variableCells = examples.tableHeader.cells;
      examples.tableBody.forEach(function (values) {
        var valueCells = values.cells;
        var steps = [].concat(backgroundSteps);
        var tags = [].concat(featureTags).concat(scenarioOutline.tags).concat(examples.tags);

        scenarioOutline.steps.forEach(function (scenarioOutlineStep) {
          var stepText = interpolate(scenarioOutlineStep.text, variableCells, valueCells);
          var arguments = createPickleArguments(scenarioOutlineStep.argument, variableCells, valueCells);
          var pickleStep = {
            keyword: scenarioOutlineStep.keyword,
            text: stepText,
            arguments: arguments,
            locations: [
              pickleLocation(values.location),
              pickleStepLocation(scenarioOutlineStep)
            ]
          };
          steps.push(pickleStep);
        });

        var pickle = {
          path: path,
          keyword: keyword,
          name: interpolate(scenarioOutline.name, variableCells, valueCells),
          steps: steps,
          tags: pickleTags(tags),
          locations: [
            pickleLocation(values.location),
            pickleLocation(scenarioOutline.location)
          ]
        };
        pickles.push(pickle);

      });
    });
  }

  function createPickleArguments(argument, variables, values) {
    var result = [];
    if (!argument) return result;
    if (argument.type === 'DataTable') {
      var table = {
        rows: argument.rows.map(function (row) {
          return {
            cells: row.cells.map(function (cell) {
              return {
                location: pickleLocation(cell.location),
                value: interpolate(cell.value, variables, values)
              };
            })
          };
        })
      };
      result.push(table);
    } else if (argument.type === 'DocString') {
      var docString = {
        location: pickleLocation(argument.location),
        content: interpolate(argument.content, variables, values)
      }
      result.push(docString);
    } else {
      throw Error('Internal error');
    }
    return result;
  }

  function interpolate(name, variableCells, valueCells) {
    variableCells.forEach(function (variableCell, n) {
      var valueCell = valueCells[n];
      var search = new RegExp('<' + variableCell.value + '>', 'g')
      name = name.replace(search, valueCell.value);
    });
    return name;
  }

  function getBackgroundSteps(background) {
    if(background) {
      return background.steps.map(function (step) {
        return pickleStep(step);
      });
    } else {
      return [];
    }
  }

  function pickleStep(step) {
    return {
      keyword: step.keyword,
      text: step.text,
      arguments: createPickleArguments(step.argument, [], []),
      locations: [pickleStepLocation(step)]
    }
  }

  function pickleStepLocation(step) {
    return {
      line: step.location.line,
      column: step.location.column + (step.keyword ? step.keyword.length : 0)
    };
  }

  function pickleLocation(location) {
    return {
      line: location.line,
      column: location.column
    }
  }

  function pickleTags(tags) {
    return tags.map(pickleTag);
  }

  function pickleTag(tag) {
    return {
      name: tag.name,
      location: pickleLocation(tag.location)
    };
  }
}

module.exports = Compiler;
