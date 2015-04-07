using System;
using System.IO;
using System.Linq;
using Gherkin.Ast;

namespace Gherkin
{
    public class Parser : Parser<Feature>
    {
        public Feature Parse(TextReader reader)
        {
            return Parse(new TokenScanner(reader));
        }

        public Feature Parse(string sourceFile)
        {
            using (var reader = new StreamReader(sourceFile))
            {
                return Parse(new TokenScanner(reader));
            }
        }
    }
}
