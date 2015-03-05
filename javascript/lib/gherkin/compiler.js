var EventEmitter = require('events').EventEmitter;
var util = require('util');

function Compiler() {
  EventEmitter.call(this);

  var self = this;
  this.compile = function(feature) {
    var backgroundSteps = feature.background ? feature.background.steps : [];

    feature.scenarioDefinitions.forEach(function (scenarioDefinition) {
      var scenario = scenarioDefinition;

      var testCase = {
        name: scenario.keyword + ": " + scenario.name,
        location: scenario.location
      };
      self.emit('test-case', testCase);

      var steps = [].concat(backgroundSteps).concat(scenario.steps);
      steps.forEach(function (step) {
        var testStep = {
          name: step.keyword + step.name,
          location: step.location
        };
        self.emit('test-step', testStep);
      });
    });
  }
};

util.inherits(Compiler, EventEmitter);
module.exports = Compiler;
