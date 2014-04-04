using System;
using System.Linq;
using Gherkin.Specs;

namespace Gherkin.AstTester
{
    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.WriteLine("Usage: Gherkin.AstTester.exe test-feature-file.feature");
                return 100;
            }

            string featureFilePath = args[0];

            return TestParser(featureFilePath);
        }

        private static int TestParser(string featureFilePath)
        {
            try
            {
                return TestParserInternal(featureFilePath);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex.Message);
                return 1;
            }
        }
        private static int TestParserInternal(string featureFilePath)
        {
            var parser = new Parser();
            var parsingResult = parser.Parse(featureFilePath);

            if (parsingResult == null)
                throw new InvalidOperationException("parser returned null");

            var astFormatter = new TestAstFormatter();
            var astText = astFormatter.FormatAst(parsingResult);
            Console.WriteLine(astText);
            return 0;
        }
    }
}
