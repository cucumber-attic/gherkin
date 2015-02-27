var error = require('tea-error');

module.exports = {
  ParserException: error('ParserException'),
  CompositeParserException: error('CompositeParserException'),
  UnexpectedEOFException: error('UnexpectedEOFException'),
  UnexpectedTokenException: error('UnexpectedTokenException')
};

// TODO: Fix constructors
