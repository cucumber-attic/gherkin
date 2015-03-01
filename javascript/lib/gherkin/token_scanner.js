var Token = require('./token');
var Location = require('./location');
var GherkinLine = require('./gherkin_line');

module.exports = function TokenScanner(source) {
  var lines = source.split('\n');
  var lineNumber = 0;

  this.read = function () {
    var line = lines[lineNumber++];
    var location = new Location(lineNumber);
    return line == null ? new Token(null, location) : new Token(new GherkinLine(line, lineNumber), location);
  }
};
