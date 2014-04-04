using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
    public class GherkinLine : IGherkinLine
    {
        private const char TITLE_KEYWORD_SEPARATOR = ':';

        private string lineText;
        private string trimmedLineText;
        public int LineNumber { get; private set; }

        public GherkinLine(string line, int lineNumber)
        {
            this.LineNumber = lineNumber;

            this.lineText = line;
            this.trimmedLineText = this.lineText.TrimStart();
        }

        public void Detach()
        {
            //nop
        }

        public int Indent
        {
            get { return lineText.Length - trimmedLineText.Length; }
        }

        public bool IsEmpty()
        {
            return trimmedLineText.Length == 0;
        }

        public bool StartsWith(string text)
        {
            return trimmedLineText.StartsWith(text);
        }

        public bool StartsWithTitleKeyword(string text)
        {
            int textLength = text.Length;
            return trimmedLineText.Length > textLength && 
                trimmedLineText.StartsWith(text) && 
                trimmedLineText[textLength] == TITLE_KEYWORD_SEPARATOR;
        }

        public string GetLineText(int indentToRemove = -1)
        {
            if (indentToRemove < 0 || indentToRemove > Indent)
                return trimmedLineText;

            return lineText.Substring(indentToRemove);
        }

        public string GetRestTrimmed(int length)
        {
            return trimmedLineText.Substring(length).Trim();
        }

        public IEnumerable<string> GetTags()
        {
	        return trimmedLineText
		        .Split(new char[0], StringSplitOptions.RemoveEmptyEntries);
        }

        public IEnumerable<string> GetTableCells()
        {
            var parts = lineText.Split('|');
            return parts.Skip(1).Take(parts.Length - 2).Select(cv => cv.Trim());
        }
    }
}
