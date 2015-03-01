var error = require('tea-error');

var Errors = {
  ParserException: error('ParserException'),
  CompositeParserException: error('CompositeParserException'),
  UnexpectedEOFException: error('UnexpectedEOFException'),
  UnexpectedTokenException: error('UnexpectedTokenException')
};

Errors.CompositeParserException.create = function(errors) {
  var message = "Parser errors: \n" + errors.map(function (e) { return e.message; }).join("\n");
  return new Errors.UnexpectedTokenException(message);
};

Errors.UnexpectedTokenException.create = function(token, expectedTokenTypes, stateComment) {
  var message = "expected: " + expectedTokenTypes.join(', ') + ", got '" + token.getTokenValue().trim() + "'";
  return new Errors.UnexpectedTokenException(message);
};

module.exports = Errors;

// TODO: Fix constructors
