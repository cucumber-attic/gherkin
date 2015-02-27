var Token = require('./token');
var Location = require('./location');

module.exports = function TokenScanner(source) {
  var lines = source.split('\n');
  var i = 0;

  this.read = function () {
    var location = new Location(i + 1);
    return new Token(lines[i++], location);
  }
};
