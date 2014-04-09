using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class ScenarioOutline : ScenarioDefinition
	{
		public Examples[] Examples { get; private set; }

		public ScenarioOutline(Tag[] tags, Location location, string keyword, string title, string description, Step[] steps, Examples[] examples) 
			: base(tags, location, keyword, title, description, steps)
		{
			Examples = examples;
		}
	}
}