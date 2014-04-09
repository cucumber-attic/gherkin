using System;
using System.Linq;
using System.Text;

namespace Gherkin.Specs
{
	public class TokenFormatterBuilder : IAstBuilder
	{
		private readonly TokenFormatter formatter = new TokenFormatter();
		private readonly StringBuilder tokensTextBuilder = new StringBuilder();

		public string GetTokensText()
		{
			return LineEndingHelper.NormalizeLineEndings(tokensTextBuilder.ToString());
		}

		public void Build(Token token)
		{
			tokensTextBuilder.AppendLine(formatter.FormatToken(token));
		}

		public void StartRule(RuleType ruleType)
		{
			//nop
		}

		public void EndRule(RuleType ruleType)
		{
			//nop
		}

		public object GetResult()
		{
			return new object();
		}
	}
}