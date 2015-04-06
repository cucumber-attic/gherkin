using System;
using System.Linq;

namespace Gherkin.AstGenerator
{
    public static class AstGenerator
    {
        public static string GenerateAst(string featureFilePath)
        {
            var parser = new Parser();
            var parsingResult = parser.Parse(featureFilePath);

            if (parsingResult == null)
                throw new InvalidOperationException("parser returned null");

            var astFormatter = new TestAstFormatter();
            var astText = astFormatter.FormatAst(parsingResult);
            return astText;
        }

    }
}
