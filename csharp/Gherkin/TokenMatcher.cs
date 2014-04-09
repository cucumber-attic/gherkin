using System;
using System.Linq;

namespace Gherkin
{
    public class TokenMatcher : ITokenMatcher
    {
        private readonly GherkinDialectProvider dialectProvider;
        private GherkinDialect currentDialect;
        private bool languageChangeAllowed = true;

        public TokenMatcher(GherkinDialectProvider dialectProvider = null)
        {
            this.dialectProvider = dialectProvider ?? new GherkinDialectProvider();

            currentDialect = this.dialectProvider.DefaultDialect;
        }

        private const string LANGUAGE_PREFIX = "language:";

        public bool Match_Comment(Token token)
        {
            if (!token.IsEOF && token.Line.StartsWith("#"))
            {
                token.MatchedType = TokenType.Comment;
                token.Text = token.Line.GetRestTrimmed(0).Substring(1);

                if (languageChangeAllowed && token.Text.StartsWith(LANGUAGE_PREFIX, StringComparison.OrdinalIgnoreCase))
                {
                    var language = token.Text.Substring(LANGUAGE_PREFIX.Length).Trim();
                    currentDialect = dialectProvider.GetDialect(language);
                }
                languageChangeAllowed = false;

                return true;
            }
            return false;
        }

        public bool Match_Empty(Token token)
        {
            if (!token.IsEOF && token.Line.IsEmpty())
            {
                token.MatchedType = TokenType.Empty;
                return true;
            }
            return false;
        }

        public bool Match_BackgroundLine(Token token)
        {
            return MatchTitleLine(token, TokenType.BackgroundLine);
        }

        private bool MatchTitleLine(Token token, TokenType tokenType)
        {
            if (token.IsEOF)
                return false;

            var keywords = currentDialect.GetTitleKeywords(tokenType);
            foreach (var keyword in keywords)
            {
                if (token.Line.StartsWithTitleKeyword(keyword))
                {
                    token.MatchedType = tokenType;
                    token.MatchedKeyword = keyword;
                    token.Text = token.Line.GetRestTrimmed(keyword.Length + 1);
	                token.Indent = token.Line.Indent;
                    languageChangeAllowed = false;
                    return true;
                }
            }
            return false;
        }

        public bool Match_TagLine(Token token)
        {
            if (!token.IsEOF && token.Line.StartsWith("@"))
            {
                token.MatchedType = TokenType.TagLine;
                token.Items = token.Line.GetTags().ToArray();
	            token.Indent = token.Line.Indent;
                languageChangeAllowed = false;

                return true;
            }
            return false;
        }

        public bool Match_ScenarioLine(Token token)
        {
            return MatchTitleLine(token, TokenType.ScenarioLine);
        }

        public bool Match_ScenarioOutlineLine(Token token)
        {
            return MatchTitleLine(token, TokenType.ScenarioOutlineLine);
        }

        public bool Match_EOF(Token token)
        {
            if (token.IsEOF)
            {
                token.MatchedType = TokenType.EOF;
                return true;
            }
            return false;
        }

        public bool Match_Other(Token token)
        {
            token.MatchedType = TokenType.Other;
            token.Text = token.Line.GetLineText(0); //take the entire line
            return true;
        }

        public bool Match_ExamplesLine(Token token)
        {
            return MatchTitleLine(token, TokenType.ExamplesLine);
        }

        public bool Match_FeatureLine(Token token)
        {
            return MatchTitleLine(token, TokenType.FeatureLine);
        }

        public bool Match_DocStringSeparator(Token token)
        {
            return Match_DocStringSeparatorInternal(token, "\"\"\"", TokenType.DocStringSeparator);
        }

        public bool Match_DocStringAlternativeSeparator(Token token)
        {
            return Match_DocStringSeparatorInternal(token, "```", TokenType.DocStringAlternativeSeparator);
        }

        private bool Match_DocStringSeparatorInternal(Token token, string separator, TokenType tokenType)
        {
            if (token.Line.StartsWith(separator))
            {
                token.MatchedType = tokenType;
                token.Indent = token.Line.Indent;
                token.Text = token.Line.GetRestTrimmed(separator.Length); // content type
                return true;
            }
            return false;
        }

        public bool Match_StepLine(Token token)
        {
            var keywords = currentDialect.StepKeywords;
            foreach (var keyword in keywords)
            {
                if (token.Line.StartsWith(keyword))
                {
                    token.MatchedType = TokenType.StepLine;
                    token.MatchedKeyword = keyword;
                    token.Text = token.Line.GetRestTrimmed(keyword.Length);
	                token.Indent = token.Line.Indent;
                    return true;
                }
            }
            return false;
        }

        public bool Match_TableRow(Token token)
        {
            if (token.Line.StartsWith("|"))
            {
                token.MatchedType = TokenType.TableRow;
                token.Items = token.Line.GetTableCells().ToArray();
				token.Indent = token.Line.Indent;
                return true;
            }
            return false;
        }
    }
}