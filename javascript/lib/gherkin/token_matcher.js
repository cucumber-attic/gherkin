var GherkinDialect = require('./gherkin_dialect');

module.exports = function TokenMatcher() {
  var dialect = new GherkinDialect();

  this.match_TagLine = function match_TagLine(token) {
    return startsWith(token.trimmedLine, '@');
  };

  this.match_FeatureLine = function match_FeatureLine(token) {
    return startsWithAny(token.trimmedLine, dialect.featureKeywords);
  };

  this.match_ScenarioLine = function match_ScenarioLine(token) {
    return startsWithAny(token.trimmedLine, dialect.scenarioKeywords);
  };

  this.match_ScenarioOutlineLine = function match_ScenarioOutlineLine(token) {
    return startsWithAny(token.trimmedLine, dialect.scenarioOutlineKeywords);
  };

  this.match_BackgroundLine = function match_BackgroundLine(token) {
    return startsWithAny(token.trimmedLine, dialect.backgroundKeywords);
  };

  this.match_ExamplesLine = function match_ExamplesLine(token) {
    return startsWithAny(token.trimmedLine, dialect.examplesKeywords);
  };

  this.match_TableRow = function match_TableRow(token) {
    return startsWith(token.trimmedLine, '|');
  };

  this.match_Empty = function match_Empty(token) {
    //token.trimmedLine != nil &&
    return token.trimmedLine === '';
  };

  this.match_Comment = function match_Comment(token) {
    return startsWith(token.trimmedLine, '#');
  };

  this.match_Language = function match_Language(token) {
    return startsWith(token.trimmedLine, '#language:'); // TODO: support '#  language :';
  };

  this.match_DocStringSeparator = function match_DocStringSeparator(token) {
    // TODO: better pair matching
    return startsWith(token.trimmedLine, '"""') || startsWith(token.trimmedLine, '```');
  };

  this.match_EOF = function match_EOF(token) {
    return token.isEof;
  };

  this.match_StepLine = function match_StepLine(token) {
    return startsWithAny(token.trimmedLine, dialect.stepKeywords);
  };

  this.match_Other = function match_Other(token) {
    true;
  };

  function startsWith(text, substring) {
    return text.indexOf(substring) == 0;
  }

  function startsWithAny(text, alternatives) {
    return find(alternatives, function (substring) {
      return startsWith(text, substring);
    });
  }

  function find(array, predicate) {
    var length = array.length;
    for (var i = 0, value; i < length; i++) {
      value = array[i];
      if (predicate(value)) return value;
    }
  }
};
