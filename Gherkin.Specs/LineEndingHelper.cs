using System;
using System.Linq;

namespace Gherkin.Specs
{
    public static class LineEndingHelper
    {
        internal static string NormalizeLineEndings(string text)
        {
            return text.Replace("\r\n", "\n").TrimEnd('\n');
        }
    }
}
