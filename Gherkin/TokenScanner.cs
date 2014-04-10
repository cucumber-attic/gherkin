using System;
using System.IO;
using System.Linq;
using Gherkin.Ast;

namespace Gherkin
{
    public class TokenScanner : ITokenScanner
    {
        protected int lineNumber = 0;
        protected readonly TextReader reader;

        public TokenScanner(TextReader reader)
        {
            this.reader = reader;
        }

        public virtual Token Read()
        {
            var line = reader.ReadLine();
            var location = new Location(++lineNumber);
            return line == null ? new Token(null, location) : new Token(new GherkinLine(line, lineNumber), location);
        }
    }
}