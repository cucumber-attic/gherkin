var EventEmitter = require('events').EventEmitter;
var util = require('util');

function Compiler() {
  EventEmitter.call(this);

  var self = this;
  this.compile = function(feature) {
    feature.scenarioDefinitions.forEach(function (scenarioDefinition) {
      var scenario = scenarioDefinition;

      var testCase = {
        location: scenario.location
      };
      self.emit('test-case', testCase);
      scenario.steps.forEach(function (step) {
        var testStep = {
          location: step.location
        };
        self.emit('test-step', testStep);
      });
    });
  }
};

util.inherits(Compiler, EventEmitter);
module.exports = Compiler;
