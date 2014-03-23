using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
    partial class ParserError
    {
        public int? LineNumber { get { return ReceivedToken.Line != null ? (int?)ReceivedToken.Line.LineNumber + 1  : null; } }
    }

    public class ParserMessageProvider
    {
        public string GetDefaultExceptionMessage(ParserError[] errors)
        {
            if (errors == null || errors.Length == 0)
                return "Parser error";

            return "Parser errors: " + Environment.NewLine + string.Join(Environment.NewLine, errors.Select(e => GetParserErrorMessage(e)));
        }

        public string GetParserErrorMessage(ParserError error)
        {
            if (error.ReceivedToken.IsEOF)
                return string.Format("Error: unexpected end of file, expected: {0}", string.Join(", ", error.ExpectedTokenTypes));

            return string.Format("Error at line {2}: expected: {0}, got '{1}'", string.Join(", ", error.ExpectedTokenTypes), error.ReceivedToken.Line.GetLineText().Trim(), error.LineNumber);
        }
    }
}
