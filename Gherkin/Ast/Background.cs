using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class Background : IHasLocation, IHasDescription, IHasSteps
	{
		public Location Location { get; private set; }
		public string Keyword { get; private set; }
		public string Title { get; private set; }
		public string Description { get; private set; }
		public Step[] Steps { get; private set; }
	}
}