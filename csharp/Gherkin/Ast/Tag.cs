using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class Tag : IHasLocation
	{
		public Location Location { get; private set; }
		public string Value { get; private set; }

		public Tag(string value, Location location)
		{
			Value = value;
			Location = location;
		}
	}
}