using System;
using System.Linq;

namespace Gherkin
{
	public class TokenMatcher : ITokenMatcher
    {
        private readonly GherkinDialectProvider dialectProvider;
        private GherkinDialect currentDialect;

        public TokenMatcher(GherkinDialectProvider dialectProvider = null)
        {
            this.dialectProvider = dialectProvider ?? new GherkinDialectProvider();

            currentDialect = this.dialectProvider.DefaultDialect;
        }

		protected virtual void SetTokenMatched(Token token, TokenType matchedType, string text = null, string keyword = null, int? indent = null, GherkinLineSpan[] items = null)
		{
			token.MatchedType = matchedType;
			token.MatchedKeyword = keyword;
			token.MatchedText = text;
			token.MathcedItems = items;
			token.MatchedIndent = indent ?? (token.Line == null ? 0 : token.Line.Indent);
		}

		public bool Match_EOF(Token token)
		{
			if (token.IsEOF)
			{
				SetTokenMatched(token, TokenType.EOF);
				return true;
			}
			return false;
		}

		public bool Match_Other(Token token)
		{
			var text = token.Line.GetLineText(0); //take the entire line
			SetTokenMatched(token, TokenType.Other, text, indent: 0);
			return true;
		}

		public bool Match_Empty(Token token)
		{
			if (!token.IsEOF && token.Line.IsEmpty())
			{
				SetTokenMatched(token, TokenType.Empty);
				return true;
			}
			return false;
		}

		public bool Match_Comment(Token token)
        {
			if (!token.IsEOF && token.Line.StartsWith(GherkinLanguageConstants.COMMENT_PREFIX))
            {
				var text = token.Line.GetLineText(0); //take the entire line
                SetTokenMatched(token, TokenType.Comment, text, indent: 0);
                return true;
            }
            return false;
        }

		public bool Match_Language(Token token)
		{
			if (!token.IsEOF && token.Line.StartsWith(GherkinLanguageConstants.LANGUAGE_PREFIX))
			{
				var language = token.Line.GetRestTrimmed(GherkinLanguageConstants.LANGUAGE_PREFIX.Length);
				currentDialect = dialectProvider.GetDialect(language);

				SetTokenMatched(token, TokenType.Language, language);
				return true;
			}
			return false;
		}

		public bool Match_TagLine(Token token)
		{
			if (!token.IsEOF && token.Line.StartsWith(GherkinLanguageConstants.TAG_PREFIX))
			{
				SetTokenMatched(token, TokenType.TagLine, items: token.Line.GetTags().ToArray());
				return true;
			}
			return false;
		}

		public bool Match_FeatureLine(Token token)
		{
			return MatchTitleLine(token, TokenType.FeatureLine, currentDialect.FeatureKeywords);
		}

		public bool Match_BackgroundLine(Token token)
        {
			return MatchTitleLine(token, TokenType.BackgroundLine, currentDialect.BackgroundKeywords);
        }

		public bool Match_ScenarioLine(Token token)
		{
			return MatchTitleLine(token, TokenType.ScenarioLine, currentDialect.ScenarioKeywords);
		}

		public bool Match_ScenarioOutlineLine(Token token)
		{
			return MatchTitleLine(token, TokenType.ScenarioOutlineLine, currentDialect.ScenarioOutlineKeywords);
		}

		public bool Match_ExamplesLine(Token token)
		{
			return MatchTitleLine(token, TokenType.ExamplesLine, currentDialect.ExamplesKeywords);
		}

        private bool MatchTitleLine(Token token, TokenType tokenType, string[] keywords)
        {
            if (token.IsEOF)
                return false;

            foreach (var keyword in keywords)
            {
                if (token.Line.StartsWithTitleKeyword(keyword))
                {
	                var title = token.Line.GetRestTrimmed(keyword.Length + GherkinLanguageConstants.TITLE_KEYWORD_SEPARATOR.Length);
                    SetTokenMatched(token, tokenType, keyword: keyword, text: title);
                    return true;
                }
            }
            return false;
        }

        public bool Match_DocStringSeparator(Token token)
        {
            return Match_DocStringSeparatorInternal(token, GherkinLanguageConstants.DOCSTRING_SEPARATOR, TokenType.DocStringSeparator);
        }

        public bool Match_DocStringAlternativeSeparator(Token token)
        {
			return Match_DocStringSeparatorInternal(token, GherkinLanguageConstants.DOCSTRING_ALTERNATIVE_SEPARATOR, TokenType.DocStringAlternativeSeparator);
        }

        private bool Match_DocStringSeparatorInternal(Token token, string separator, TokenType tokenType)
        {
            if (token.Line.StartsWith(separator))
            {
	            var contentType = token.Line.GetRestTrimmed(separator.Length);
                SetTokenMatched(token, tokenType, contentType);
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
	                var stepText = token.Line.GetRestTrimmed(keyword.Length);
                    SetTokenMatched(token, TokenType.StepLine, keyword: keyword, text: stepText);
                    return true;
                }
            }
            return false;
        }

        public bool Match_TableRow(Token token)
        {
            if (token.Line.StartsWith(GherkinLanguageConstants.TABLE_CELL_SEPARATOR))
            {
                SetTokenMatched(token, TokenType.TableRow, items: token.Line.GetTableCells().ToArray());
                return true;
            }
            return false;
        }
    }
}