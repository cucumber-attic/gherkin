using System;
using System.Linq;
using Gherkin.Specs;

namespace Gherkin.ParserTester
{
    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.WriteLine("Usage: Gherkin.ParserTester.exe test-feature-file.feature");
                return 100;
            }

            string featureFilePath = args[0];

            TestParser(featureFilePath);
            return 0;
        }

        private static void TestParser(string featureFilePath)
        {
            try
            {
                TestParserInternal(featureFilePath);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex.Message);                
            }
        }
        private static void TestParserInternal(string featureFilePath)
        {
            var parser = new Parser();
            var parsingResult = parser.Parse(featureFilePath);

            if (parsingResult == null)
                throw new InvalidOperationException("parser returned null");

            var astFormatter = new TestAstFormatter();
            var astText = astFormatter.FormatAst(parsingResult);
            Console.WriteLine(astText);
        }
    }
}
