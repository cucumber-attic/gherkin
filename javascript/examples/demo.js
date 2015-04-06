var input = document.getElementById('input');
var output = document.getElementById('output');
var parser = new Gherkin.Parser();

function parse() {
  console.log('parsing');
  var result;
  try {
    var builder = new Gherkin.AstBuilder();
    parser.stopAtFirstError = false;

    var scanner = new Gherkin.TokenScanner(input.value);
    var ast = parser.parse(scanner, builder, new Gherkin.TokenMatcher());
    result = JSON.stringify(ast, null, 2);
  } catch (e) {
    result = e.message;
  }
  output.innerText = result;
}

input.onkeyup = function () {
  parse();
};

parse();
