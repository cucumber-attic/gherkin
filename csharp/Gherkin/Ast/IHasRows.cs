using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public interface IHasRows
    {
        IEnumerable<TableRow> Rows { get; }
    }
}