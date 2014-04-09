using System;
using System.IO;
using System.Linq;

namespace Gherkin
{
    public class TokenScanner
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
            return line == null ? new Token(null) : new Token(new GherkinLine(line, ++lineNumber));
        }
    }
}