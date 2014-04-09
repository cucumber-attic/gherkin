using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class Step : IHasLocation
	{
		public Location Location { get; private set; }
		public string Keyword { get; private set; }
		public string Text { get; private set; }
		public StepArgument StepArgument { get; private set; }

		public Step(Location location, string keyword, string text, StepArgument stepArgument)
		{
			Location = location;
			Keyword = keyword;
			Text = text;
			StepArgument = stepArgument;
		}
	}
}