using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class Tag : IHasLocation
	{
		public Location Location { get; private set; }
		public string Value { get; private set; }

		public Tag(Location location, string value)
		{
			Value = value;
			Location = location;
		}
	}
}