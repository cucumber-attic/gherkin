using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class DataTable : StepArgument, IHasRows
	{
		public TableRow[] Rows { get; private set; }

		public DataTable(TableRow[] rows)
		{
			Rows = rows;
		}
	}
}