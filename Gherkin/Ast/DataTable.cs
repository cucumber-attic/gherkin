using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class DataTable : StepArgument, IHasLocation, IHasRows
	{
		public Location Location { get; private set; }
		public TableRow[] Rows { get; private set; }
	}
}