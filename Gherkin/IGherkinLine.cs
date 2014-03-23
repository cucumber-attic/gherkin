using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
    public interface IGherkinLine
    {
        int LineNumber { get; }

        void Detach();

        int Indent { get; }
        bool IsEmpty();
        bool StartsWith(string text);
        bool StartsWithTitleKeyword(string text);
        string GetLineText(int indentToRemove = -1);
        string GetRestTrimmed(int length);
        IEnumerable<string> GetTags();
        IEnumerable<string> GetTableCells();
    }
}
