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

module.exports = AstNode;
