using System;
using System.Linq;

namespace Gherkin.Specs
{
	public class TokenFormatter
	{
		public string FormatToken(Token token)
		{
			if (token.IsEOF)
				return "EOF";

			return string.Format("({0}:{1}){2}:{3}/{4}/{5}", 
				token.Line.LineNumber + 1,
				token.Indent + 1,
				token.MatchedType,
				token.MatchedKeyword,
				token.Text,
				token.Items == null ? "" : string.Join(",", token.Items.Select(i => i.Column + ":" + i.Text))
				);
		}
	}
}
