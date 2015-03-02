module.exports = function TokenFormatterBuilder() {
  var tokensText = '';

  this.startRule = function(ruleType) {};

  this.endRule = function(ruleType) {};

  this.build = function(token) {
    tokensText += formatToken(token) + '\n';
  };

  this.getResult = function() {
    return tokensText;
  }

  function formatToken(token) {
    if(token.isEof) return 'EOF';

    return "(" +
    token.location.line +
    ":" +
    token.location.column +
    ")" +
    token.matchedType +
    ":" +
    (token.matchedKeyword === undefined ? '' : token.matchedKeyword) +
    "/" +
    (token.matchedText === undefined ? '' : token.matchedText) +
    "/" +
    token.matchedItems.map(function (i) { return i.column + ':' + i.text; }).join(',');
  }

  function format(format) {
    var args = Array.prototype.slice.call(arguments, 1);
    return format.replace(/{(\d+)}/g, function(match, number) {
      return typeof args[number] != 'undefined'
      ? args[number]
      : match
      ;
    });
  };
};
