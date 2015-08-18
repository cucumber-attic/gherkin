using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin
{
    public class GherkinLine : IGherkinLine
    {
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
                   StartsWithFrom(trimmedLineText, textLength, GherkinLanguageConstants.TITLE_KEYWORD_SEPARATOR);
        }

        private static bool StartsWithFrom(string text, int textIndex, string value)
        {
            return string.CompareOrdinal(text, textIndex, value, 0, value.Length) == 0;
        }

        public string GetLineText(int indentToRemove)
        {
            if (indentToRemove < 0 || indentToRemove > Indent)
                return trimmedLineText;

            return lineText.Substring(indentToRemove);
        }

        public string GetRestTrimmed(int length)
        {
            return trimmedLineText.Substring(length).Trim();
        }

        public IEnumerable<GherkinLineSpan> GetTags()
        {
            int position = Indent;
            foreach (string item in trimmedLineText.Split())
            {
                if (item.Length > 0)
                {
                    yield return new GherkinLineSpan(position + 1, item);
                    position += item.Length;
                }
                position++; // separator
            }
        }
        public IEnumerable<GherkinLineSpan> GetTableCells()
        {
            int position = Indent;
            var items = SplitCells(trimmedLineText).ToList();
            bool isBeforeFirst = true;
            foreach (var item in items.Take(items.Count - 1)) // skipping the one after last
            {
                if (!isBeforeFirst)
                {
                    int trimmedStart;
                    var cellText = Trim(item, out trimmedStart);
                    var cellPosition = position + trimmedStart;

                    if (cellText.Length == 0)
                        cellPosition = position;

                    yield return new GherkinLineSpan(cellPosition + 1, cellText);
                }

                isBeforeFirst = false;
                position += item.Length;
                position++; // separator
            }
        }

        private IEnumerable<string> SplitCells(string row)
        {
            var rowEnum = row.GetEnumerator();
            string cell = "";
            while (rowEnum.MoveNext()) {
                char c = rowEnum.Current;
                if (c.ToString() == GherkinLanguageConstants.TABLE_CELL_SEPARATOR) {
                    yield return cell;
                    cell = "";
                } else if (c == GherkinLanguageConstants.TABLE_CELL_ESCAPE_CHAR) {
                    rowEnum.MoveNext();
                    c = rowEnum.Current;
                    if (c == GherkinLanguageConstants.TABLE_CELL_NEWLINE_ESCAPE) {
                        cell += "\n";
                    } else {
                        cell += c;
                    }
                } else {
                    cell += c;
                }
            }
            yield return cell;
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
