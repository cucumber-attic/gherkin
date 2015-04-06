using System;
using System.IO;
using System.Linq;
using Gherkin.Specs;

namespace Gherkin.TokensTester
{
    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.WriteLine("Usage: Gherkin.TokenTester.exe test-feature-file.feature");
                return 100;
            }

            string featureFilePath = args[0];

            return TestTokens(featureFilePath);
        }

        private static int TestTokens(string featureFilePath)
        {
            try
            {
                return TestTokensInternal(featureFilePath);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex.Message);
                return 1;
            }
        }

        private static int TestTokensInternal(string featureFilePath)
        {
            var parser = new Parser<object>();
            var tokenFormatterBuilder = new TokenFormatterBuilder();
            using (var reader = new StreamReader(featureFilePath))
                parser.Parse(new TokenScanner(reader), new TokenMatcher(), tokenFormatterBuilder);

            var tokensText = tokenFormatterBuilder.GetTokensText();
            Console.WriteLine(tokensText);
            return 0;
        }
    }
}
