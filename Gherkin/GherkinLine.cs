using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin
{
    public class GherkinLine : IGherkinLine
    {
        private const char TITLE_KEYWORD_SEPARATOR = ':';
        private const char TABLE_CELL_SEPARATOR = '|';

        private readonly string lineText;
        private readonly string trimmedLineText;
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

        public IEnumerable<KeyValuePair<int, string>> GetTags()
        {
	        int position = Indent;
	        foreach (string item in trimmedLineText.Split())
	        {
		        if (item.Length > 0)
		        {
			        yield return new KeyValuePair<int, string>(position, item);
			        position += item.Length;
		        }
		        position++; // separator
	        }
        }
		public IEnumerable<KeyValuePair<int, string>> GetTableCells()
		{
			int position = Indent;
			string[] items = trimmedLineText.Split(TABLE_CELL_SEPARATOR);
			bool isBeforeFirst = true;
			foreach (var item in items.Take(items.Length - 1)) // skipping the one after last
			{
				if (!isBeforeFirst)
				{
					int trimmedStart;
					var cellText = Trim(item, out trimmedStart);
					var cellPosition = position + trimmedStart;

					if (cellText.Length == 0)
						cellPosition = position;

					yield return new KeyValuePair<int, string>(cellPosition, cellText);
				}

				isBeforeFirst = false;
				position += item.Length;
				position++; // separator
			}
		}

	    private string Trim(string s, out int trimmedStart)
	    {
		    trimmedStart = 0;
		    while (trimmedStart < s.Length && char.IsWhiteSpace(s[trimmedStart]))
			    trimmedStart++;

		    return s.Trim();
	    }
    }
}
