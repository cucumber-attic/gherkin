module.exports = function Token(line, location) {
  this.line = line;
  this.location = location;
  this.trimmedLine = line && line.trim();
  this.isEof = line === null || line === undefined;
  this.matchedItems = [];
  this.detach = function() {};
};
