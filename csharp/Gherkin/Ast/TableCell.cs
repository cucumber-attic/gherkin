using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class TableCell : IHasLocation
	{
		public Location Location { get; private set; }
		public string Value { get; private set; }

		public TableCell(string value, Location location)
		{
			Location = location;
			this.Value = value;
		}
	}
}