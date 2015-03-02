var AstNode = require('./ast_node');

module.exports = function AstBuilder () {

  var stack = [new AstNode('None')];

  this.startRule = function (ruleType) {
    stack.push(new AstNode(ruleType));
  };

  this.endRule = function (ruleType) {
    var node = stack.pop();
    var transformedNode = transformNode(node);
    currentNode().add(node.ruleType, transformedNode);
  };

  this.build = function (token) {
    currentNode().add(token.matchedType, token);
  };

  this.getResult = function () {
    return currentNode().getSingle('Feature');
  };

  function currentNode () {
    return stack[stack.length - 1];
  }

  function transformNode(node) {
    return node;
  }

};
