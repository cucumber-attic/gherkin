using System;
using System.Linq;

namespace Gherkin.AstGenerator
{
    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length < 1)
            {
                Console.WriteLine("Usage: Gherkin.AstGenerator.exe test-feature-file.feature");
                return 100;
            }

            var startTime = Environment.TickCount;
            foreach (var featureFilePath in args)
            {
                try
                {
                    var astText = AstGenerator.GenerateAst(featureFilePath);
                    Console.WriteLine(astText);
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine(ex.Message);
                    return 1;
                }
            }
            var endTime = Environment.TickCount;
            if (Environment.GetEnvironmentVariable("GHERKIN_PERF") != null)
            {
                Console.Error.WriteLine(endTime - startTime);
            }
            return 0;
        }
    }
}
