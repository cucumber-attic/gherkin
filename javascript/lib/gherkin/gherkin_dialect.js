module.exports = function GherkinDialect() {
  this.featureKeywords = ['Feature:'];
  this.backgroundKeywords = ['Background:'];
  this.scenarioKeywords = ['Scenario:'];
  this.scenarioOutlineKeywords = ['Scenario Outline:', 'Scenario Template:'];
  this.examplesKeywords = ['Examples:', 'Scenarios:'];
  this.stepKeywords = ['Given ', 'When ', 'Then ', 'And ', 'But ', '* '];
};
