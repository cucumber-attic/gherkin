var dialects = require('./dialects.json');
var Errors = require('./errors');

module.exports = function TokenMatcher() {
  var dialect = dialects['en'];

  this.match_TagLine = function match_TagLine(token) {
    if(token.line.startsWith('@')) {
      setTokenMatched(token, 'TagLine', null, null, null, token.line.getTags());
      return true;
    }
    return false;
  };

  this.match_FeatureLine = function match_FeatureLine(token) {
    return matchTitleLine(token, 'FeatureLine', dialect.feature);
  };

  this.match_ScenarioLine = function match_ScenarioLine(token) {
    return matchTitleLine(token, 'ScenarioLine', dialect.scenario);
  };

  this.match_ScenarioOutlineLine = function match_ScenarioOutlineLine(token) {
    return matchTitleLine(token, 'ScenarioOutlineLine', dialect.scenarioOutline);
  };

  this.match_BackgroundLine = function match_BackgroundLine(token) {
    return matchTitleLine(token, 'BackgroundLine', dialect.background);
  };

  this.match_ExamplesLine = function match_ExamplesLine(token) {
    return matchTitleLine(token, 'ExamplesLine', dialect.examples);
  };

  this.match_TableRow = function match_TableRow(token) {
    if (token.line.startsWith('|')) {
      // TODO: indent
      setTokenMatched(token, 'TableRow', null, null, null, token.line.getTableCells());
      return true;
    }
    return false;
  };

  this.match_Empty = function match_Empty(token) {
    if (token.line.isEmpty) {
      setTokenMatched(token, 'Empty', null, null, 0);
      return true;
    }
    return false;
  };

  this.match_Comment = function match_Comment(token) {
    if(token.line.startsWith('#')) {
      var text = token.line.getLineText(0); //take the entire line, including leading space
      setTokenMatched(token, 'Comment', text, null, 0);
      return true;
    }
    return false;
  };

  this.match_Language = function match_Language(token) {
    if(token.line.startsWith('#language:')) {
      var language = token.line.getRestTrimmed('#language:'.length);
      dialect = dialects[language];
      if(!dialect) {
        throw new Error("Unknown dialect: " + language);
      }
      setTokenMatched(token, 'Language', language);
      return true;
    }
    return false;
  };

  var activeDocStringSeparator = null;
  var indentToRemove = null;

  this.match_DocStringSeparator = function match_DocStringSeparator(token) {
    return activeDocStringSeparator == null
      ?
      // open
      _match_DocStringSeparator(token, '"""', true) ||
      _match_DocStringSeparator(token, '```', true)
      :
      // close
      _match_DocStringSeparator(token, activeDocStringSeparator, false);
  };

  function _match_DocStringSeparator(token, separator, isOpen) {
    if (token.line.startsWith(separator)) {
      var contentType = null;
      if (isOpen) {
        contentType = token.line.getRestTrimmed(separator.length);
        activeDocStringSeparator = separator;
        indentToRemove = token.line.indent;
      } else {
        activeDocStringSeparator = null;
        indentToRemove = 0;
      }

      // TODO: Use the separator as keyword. That's needed for pretty printing.
      setTokenMatched(token, 'DocStringSeparator', contentType);
      return true;
    }
    return false;
  }

  this.match_EOF = function match_EOF(token) {
    if(token.isEof) {
      setTokenMatched(token, 'EOF');
      return true;
    }
    return false;
  };

  this.match_StepLine = function match_StepLine(token) {
    var keywords = []
      .concat(dialect.given)
      .concat(dialect.when)
      .concat(dialect.then)
      .concat(dialect.and)
      .concat(dialect.but);
    var length = keywords.length;
    for(var i = 0, keyword; i < length; i++) {
      var keyword = keywords[i];

      if (token.line.startsWith(keyword)) {
        var title = token.line.getRestTrimmed(keyword.length);
        setTokenMatched(token, 'StepLine', title, keyword);
        return true;
      }
    }
    return false;
  };

  this.match_Other = function match_Other(token) {
    var text = token.line.getLineText(indentToRemove); //take the entire line, except removing DocString indents
    setTokenMatched(token, 'Other', text, null, 0);
    return true;
  };

  function matchTitleLine(token, tokenType, keywords) {
    var length = keywords.length;
    for(var i = 0, keyword; i < length; i++) {
      var keyword = keywords[i];

      if (token.line.startsWithTitleKeyword(keyword)) {
        var title = token.line.getRestTrimmed(keyword.length + ':'.length);
        setTokenMatched(token, tokenType, title, keyword);
        return true;
      }
    }
    return false;
  }

  function setTokenMatched(token, matchedType, text, keyword, indent, items) {
    token.matchedType = matchedType;
    token.matchedText = text;
    token.matchedKeyword = keyword;
    token.matchedIndent = (typeof indent === 'number') ? indent : (token.line == null ? 0 : token.line.indent);
    token.matchedItems = items || [];

    token.location.column = token.matchedIndent + 1;
    token.matchedGherkinDialect = null // TODO: getCurrentDialect();
  }
};
