using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class Step : IHasLocation
	{
		public Location Location { get; private set; }
		public string Keyword { get; private set; }
		public string Value { get; private set; }
		public StepArgument StepArgument { get; private set; }

		public Step(string keyword, string value, StepArgument stepArgument, Location location)
		{
			Location = location;
			Keyword = keyword;
			Value = value;
			StepArgument = stepArgument;
		}
	}
}