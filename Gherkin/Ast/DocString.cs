using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class DocString : StepArgument, IHasLocation
	{
		public Location Location { get; private set; }
		public string ContentType { get; private set; }
		public string Content { get; private set; }
	}
}