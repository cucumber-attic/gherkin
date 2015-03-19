using System;
using System.Linq;
using Gherkin.Ast;
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

            return TestAst(featureFilePath);
        }

        private static int TestAst(string featureFilePath)
        {
            try
            {
                return TestAstInternal(featureFilePath);
            }
            catch (Exception ex)
            {
				// Ideally we'd write to STDERR here, but 2> doesn't seem
				// to work on mono for some reason :-/
                Console.WriteLine(ex.Message);
                return 1;
            }
        }
        private static int TestAstInternal(string featureFilePath)
        {
            var parser = new Parser();
            var parsingResult = (Feature)parser.Parse(featureFilePath);

            if (parsingResult == null)
                throw new InvalidOperationException("parser returned null");

            var astFormatter = new TestAstFormatter();
            var astText = astFormatter.FormatAst(parsingResult);
            Console.WriteLine(astText);
            return 0;
        }
    }
}
