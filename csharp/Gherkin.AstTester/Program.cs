using System;
using System.Linq;
using Gherkin.Ast;

namespace Gherkin.AstTester
{
    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length < 1)
            {
                Console.WriteLine("Usage: Gherkin.AstTester.exe test-feature-file.feature");
                return 100;
            }

            foreach (var featureFilePath in args)
            {
                try
                {
                    var astText = AstGenerator.GenerateAst(featureFilePath);
                    Console.WriteLine(astText);
                }
                catch (Exception ex)
                {
                    // Ideally we'd write to STDERR here, but 2> doesn't seem
                    // to work on mono for some reason :-/
                    Console.WriteLine(ex.Message);
                    return 1;
                }
            }
            return 0;
        }
    }
}
