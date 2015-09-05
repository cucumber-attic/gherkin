/**
 * Nodes are created by the `AstBuilder`, and are the building blocks of the AST (Abstract Syntax Tree). 
 * Every node has a `Location` that describes the line number and column number in the input file. 
 * These numbers are 1-indexed.
 * 
 * All fields on nodes are strings (except for `Location.line` and `Location.column`).
 * 
 * The implementation is simple objects without behaviour, only data. 
 * It's up to the implementation to decide whether to use classes or just basic collections, 
 * but the AST must have a JSON representation (this is used for testing).
 * 
 * Each node in the JSON representation also has a `type` property with the name of the node type.
 */
function AstNode (ruleType) {
  this.ruleType = ruleType;
  this._subItems = {};
}

AstNode.prototype.add = function (ruleType, obj) {
  var items = this._subItems[ruleType];
  if(items === undefined) this._subItems[ruleType] = items = [];
  items.push(obj);
}

AstNode.prototype.getSingle = function (ruleType) {
  return (this._subItems[ruleType] || [])[0];
}

AstNode.prototype.getItems = function (ruleType) {
  return this._subItems[ruleType] || [];
}

AstNode.prototype.getToken = function (tokenType) {
  return this.getSingle(tokenType);
}

AstNode.prototype.getTokens = function (tokenType) {
  return this._subItems[tokenType] || [];
}

module.exports = AstNode;
