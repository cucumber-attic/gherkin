using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public class DataTable : StepArgument, IHasRows
    {
        public IEnumerable<TableRow> Rows { get; private set; }

        public DataTable(TableRow[] rows)
        {
            Rows = rows;
        }
    }
}