using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
	partial class UnexpectedTokenError
    {
        public int? LineNumber { get { return ReceivedToken.Line != null ? (int?)ReceivedToken.Line.LineNumber  : null; } }
    }

    public class ParserMessageProvider : IParserMessageProvider
    {
        public string GetDefaultExceptionMessage(ParserError[] errors)
        {
            if (errors == null || errors.Length == 0)
                return "Parser error";

            return "Parser errors: " + Environment.NewLine + string.Join(Environment.NewLine, errors.Select(e => GetParserErrorMessage(e)));
        }

        public string GetParserErrorMessage(ParserError error)
        {
	        var unexpectedTokenError = error as UnexpectedTokenError;
			if (unexpectedTokenError != null)
			{
				if (unexpectedTokenError.ReceivedToken.IsEOF)
					return string.Format("Error: unexpected end of file, expected: {0}", string.Join(", ", unexpectedTokenError.ExpectedTokenTypes));

				return string.Format("Error at line {2}: expected: {0}, got '{1}'", 
					string.Join(", ", unexpectedTokenError.ExpectedTokenTypes), 
					unexpectedTokenError.ReceivedToken.Line.GetLineText().Trim(), 
					unexpectedTokenError.LineNumber);
			}

	        return error.ToString();
        }
    }
}
