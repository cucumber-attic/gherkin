using System;
using System.IO;
using Gherkin.Ast;

namespace Gherkin
{
    public class Parser : Parser<Feature>
    {
        private readonly AstBuilder<Feature> astBuilder;

        public Parser()
            : this (new AstBuilder<Feature>())
        {
        }

        public Parser(AstBuilder<Feature> astBuilder)
        {
            this.astBuilder = astBuilder;
        }

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

        public Feature Parse(TokenScanner tokenScanner, TokenMatcher tokenMatcher)
        {
            return base.Parse(tokenScanner, tokenMatcher, this.astBuilder);
        }
    }
}
