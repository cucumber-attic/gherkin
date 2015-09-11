var dialects = require('./gherkin-languages.json');

function Compiler() {
  this.compile = function (feature) {
    var testCases = [];
    var backgroundSteps = feature.background ? feature.background.steps : [];

    var dialect = dialects[feature.language];

    feature.scenarioDefinitions.forEach(function (scenarioDefinition) {
      if(scenarioDefinition.type === 'Scenario') {
        compileScenario(backgroundSteps, scenarioDefinition, dialect, testCases);
      } else {
        compileScenarioOutline(backgroundSteps, scenarioDefinition, dialect, testCases);
      }
    });
    return testCases;
  };

  function compileScenario(backgroundSteps, scenario, dialect, testCases) {
    var testCase = {
      name: scenario.keyword + ": " + scenario.name,
      locations: [scenario.location],
      steps: []
    };
    testCases.push(testCase);

    var steps = [].concat(backgroundSteps).concat(scenario.steps);
    steps.forEach(function (step) {
      var testStep = {
        name: step.keyword + step.text,
        text: step.text,
        locations: [step.location]
      };
      testCase.steps.push(testStep);
    });
  }

  function compileScenarioOutline(backgroundSteps, scenarioOutline, dialect, testCases) {
    scenarioOutline.examples.forEach(function (examples) {
      examples.tableBody.forEach(function (values) {
        var scenarioName = interpolate(scenarioOutline.name, examples.tableHeader, values);
        var keyword = dialect.scenario[0];

        var testCase = {
          name: keyword + ": " + scenarioName,
          locations: [values.location, scenarioOutline.location],
          steps: []
        };
        testCases.push(testCase);

        var steps = [].concat(backgroundSteps);
        scenarioOutline.steps.forEach(function (scenarioOutlineStep) {
          var testStepArgument = createTestCaseArgument(scenarioOutlineStep.argument, examples.tableHeader, values);
          testStepText = interpolate(scenarioOutlineStep.text, examples.tableHeader, values);
          var testStep = {
            name: scenarioOutlineStep.keyword + testStepText,
            text: testStepText,
            argument: testStepArgument,
            locations: [values.location, scenarioOutlineStep.location]
          };
          testCase.steps.push(testStep);
        });
      });
    });
  }

  function createTestCaseArgument(argument, variables, values) {
    if (!argument) return null;
    if (argument.type === 'DataTable') {
      var result = {
        type: argument.type,
        locations: [values.location, argument.location],
        rows: argument.rows.map(function (row) {
          return {
            type: row.type,
            locations: [values.location, row.location],
            cells: row.cells.map(function (cell) {
              return {
                type: cell.type,
                locations: [values.location, cell.location],
                value: interpolate(cell.value, variables, values)
              };
            })
          };
        })
      };
      return result;
    }
    if (argument.type === 'DocString') {
      return {
        type: argument.type,
        locations: [values.location, argument.location],
        content: interpolate(argument.content, variables, values)
      }
    }
    throw Error('Internal error');
  }

  function interpolate(name, variables, values) {
    variables.cells.forEach(function (headerCell, n) {
      var valueCell = values.cells[n];
      name = name.replace('<' + headerCell.value + '>', valueCell.value);
    });
    return name;
  }
}

module.exports = Compiler;
