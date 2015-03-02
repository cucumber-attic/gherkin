var GherkinDialect = require('./gherkin_dialect');
var Errors = require('./errors');

module.exports = function TokenMatcher() {
  var dialect = new GherkinDialect();

  this.match_TagLine = function match_TagLine(token) {
    if(token.line.startsWith('@')) {
      setTokenMatched(token, 'TagLine', language);
      return true;
    }
    return false;
  };

  this.match_FeatureLine = function match_FeatureLine(token) {
    return matchTitleLine(token, 'FeatureLine', dialect.featureKeywords);
  };

  this.match_ScenarioLine = function match_ScenarioLine(token) {
    return matchTitleLine(token, 'ScenarioLine', dialect.scenarioKeywords);
  };

  this.match_ScenarioOutlineLine = function match_ScenarioOutlineLine(token) {
    return matchTitleLine(token, 'ScenarioOutlineLine', dialect.scenarioOutlineKeywords);
  };

  this.match_BackgroundLine = function match_BackgroundLine(token) {
    return matchTitleLine(token, 'BackgroundLine', dialect.backgroundKeywords);
  };

  this.match_ExamplesLine = function match_ExamplesLine(token) {
    return matchTitleLine(token, 'ExamplesLine', dialect.examplesKeywords);
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
      setTokenMatched(token, 'Empty');
      return true;
    }
    return false;
  };

  this.match_Comment = function match_Comment(token) {
    if(token.line.startsWith('#')) {
      var text = token.line.getLineText(0); //take the entire line
      setTokenMatched(token, 'Comment', text);
      return true;
    }
    return false;
  };

  this.match_Language = function match_Language(token) {
    if(token.line.startsWith('#language:')) {
      var language = token.line.getRestTrimmed('#language:');
      try {
        dialect = dialectProvider.getDialect(language);
      } catch (e) {
        throw new Errors.CreateTokenMatcherException(token, e.message);
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
        contentType = token.line.getRestTrimmed(separator.Length);
        activeDocStringSeparator = separator;
        indentToRemove = token.line.indent;
      } else {
        activeDocStringSeparator = null;
        indentToRemove = 0;
      }

      setTokenMatched(token, 'DocStringSeparator', contentType);
      return true;
    }
    return false;
  }

  this.match_EOF = function match_EOF(token) {
    return token.isEof;
  };

  this.match_StepLine = function match_StepLine(token) {
    var keywords = dialect.stepKeywords;
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
    true;
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
    token.mathcedItems = items || [];

    token.location.column = token.matchedIndent + 1;
    token.matchedGherkinDialect = null // TODO: getCurrentDialect();
  }
};
