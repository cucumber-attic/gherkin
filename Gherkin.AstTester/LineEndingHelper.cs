using System;
using System.Linq;

namespace Gherkin.AstTester
{
    public static class LineEndingHelper
    {
        public static string NormalizeLineEndings(string text)
        {
            return text.Replace("\r\n", "\n").TrimEnd('\n');
        }
    }
}
