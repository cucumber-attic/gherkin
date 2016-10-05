var stream = require('stream')
var es = require('event-stream')
var Gherkin = require('../..');

var compiler = new Gherkin.Compiler();
var parser = new Gherkin.Parser(new Gherkin.AstBuilder());
parser.stopAtFirstError = false;

module.exports = function io(input, output, options) {
  input
    .pipe(es.split())
    .pipe(es.mapSync(function (line) {
      return line ? JSON.parse(line) : undefined
    }))
    .pipe(new stream.Transform({
      objectMode: true,
      transform: function (event, _, callback) {
        if (event.type === 'source') {
          var gherkinDocument = parser.parse(event.data);

          if (options.printSource)
            this.push(event)

          if (options.printAst)
            this.push(gherkinDocument);

          if (options.printPickles) {
            var pickles = compiler.compile(gherkinDocument, event.uri);
            pickles.map(this.push.bind(this));
          }
        } else {
          this.push(event)
        }
      }
    }))
    .pipe(es.mapSync(JSON.stringify))
    .pipe(es.join('\n'))
    .pipe(output)
}
