using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin
{
    public class Token
    {
        public bool IsEOF { get { return Line == null; } }
        public IGherkinLine Line { get; set; }
        public TokenType MatchedType { get; set; }
        public string MatchedKeyword { get; set; }
        public string Text { get; set; }
        public KeyValuePair<int, string>[] Items { get; set; }
        public int Indent { get; set; }

        public Token(IGherkinLine line)
        {
            Line = line;
        }

        public void Detach()
        {
            Line.Detach();
        }

        public override string ToString()
        {
            return string.Format("{0}: {1}/{2}", MatchedType, MatchedKeyword, Text);
        }
    }
}