var countSymbols = require('../count_symbols')

function Compiler() {
  this.compile = function (gherkin_document, path) {
    var pickles = [];

    if (gherkin_document.feature == null) return pickles;

    var feature = gherkin_document.feature;
    var featureTags = feature.tags;
    var backgroundSteps = [];

    feature.children.forEach(function (scenarioDefinition) {
      if(scenarioDefinition.type === 'Background') {
        backgroundSteps = pickleSteps(scenarioDefinition, path);
      } else if(scenarioDefinition.type === 'Scenario') {
        compileScenario(featureTags, backgroundSteps, scenarioDefinition, path, pickles);
      } else {
        compileScenarioOutline(featureTags, backgroundSteps, scenarioDefinition, path, pickles);
      }
    });
    return pickles;
  };

  function compileScenario(featureTags, backgroundSteps, scenario, path, pickles) {
    if (scenario.steps.length == 0) return;

    var steps = [].concat(backgroundSteps);

    var tags = [].concat(featureTags).concat(scenario.tags);

    scenario.steps.forEach(function (step) {
      steps.push(pickleStep(step, path));
    });

    var pickle = {
      tags: pickleTags(tags, path),
      name: scenario.name,
      locations: [pickleLocation(scenario.location, path)],
      steps: steps
    };
    pickles.push(pickle);
  }

  function compileScenarioOutline(featureTags, backgroundSteps, scenarioOutline, path, pickles) {
    if (scenarioOutline.steps.length == 0) return;

    scenarioOutline.examples.filter(function(e) { return e.tableHeader != undefined; }).forEach(function (examples) {
      var variableCells = examples.tableHeader.cells;
      examples.tableBody.forEach(function (values) {
        var valueCells = values.cells;
        var steps = [].concat(backgroundSteps);
        var tags = [].concat(featureTags).concat(scenarioOutline.tags).concat(examples.tags);

        scenarioOutline.steps.forEach(function (scenarioOutlineStep) {
          var stepText = interpolate(scenarioOutlineStep.text, variableCells, valueCells);
          var args = createPickleArguments(scenarioOutlineStep.argument, variableCells, valueCells, path);
          var pickleStep = {
            text: stepText,
            arguments: args,
            locations: [
              pickleLocation(values.location, path),
              pickleStepLocation(scenarioOutlineStep, path)
            ]
          };
          steps.push(pickleStep);
        });

        var pickle = {
          name: interpolate(scenarioOutline.name, variableCells, valueCells),
          steps: steps,
          tags: pickleTags(tags, path),
          locations: [
            pickleLocation(values.location, path),
            pickleLocation(scenarioOutline.location, path)
          ]
        };
        pickles.push(pickle);

      });
    });
  }

  function createPickleArguments(argument, variableCells, valueCells, path) {
    var result = [];
    if (!argument) return result;
    if (argument.type === 'DataTable') {
      var table = {
        rows: argument.rows.map(function (row) {
          return {
            cells: row.cells.map(function (cell) {
              return {
                location: pickleLocation(cell.location, path),
                value: interpolate(cell.value, variableCells, valueCells)
              };
            })
          };
        })
      };
      result.push(table);
    } else if (argument.type === 'DocString') {
      var docString = {
        location: pickleLocation(argument.location, path),
        content: interpolate(argument.content, variableCells, valueCells)
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

  function pickleSteps(scenarioDefinition, path) {
    return scenarioDefinition.steps.map(function (step) {
      return pickleStep(step, path);
    });
  }

  function pickleStep(step, path) {
    return {
      text: step.text,
      arguments: createPickleArguments(step.argument, [], [], path),
      locations: [pickleStepLocation(step, path)]
    }
  }

  function pickleStepLocation(step, path) {
    return {
      path: path,
      line: step.location.line,
      column: step.location.column + (step.keyword ? countSymbols(step.keyword) : 0)
    };
  }

  function pickleLocation(location, path) {
    return {
      path: path,
      line: location.line,
      column: location.column
    }
  }

  function pickleTags(tags, path) {
    return tags.map(function (tag) {
      return pickleTag(tag, path);
    });
  }

  function pickleTag(tag, path) {
    return {
      name: tag.name,
      location: pickleLocation(tag.location, path)
    };
  }
}

module.exports = Compiler;
