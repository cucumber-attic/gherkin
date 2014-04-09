using System;
using System.Linq;

namespace Gherkin.Specs
{
	public class TestTokenFormatter
	{
		public string FormatToken(Token token)
		{
			if (token.IsEOF)
				return "EOF";

			return string.Format("({0}:{1}){2}:{3}/{4}/{5}", 
				token.Line.LineNumber,
				token.MatchedIndent + 1,
				token.MatchedType,
				token.MatchedKeyword,
				token.MatchedText,
				token.MathcedItems == null ? "" : string.Join(",", token.MathcedItems.Select(i => i.Column + ":" + i.Text))
				);
		}
	}
}
