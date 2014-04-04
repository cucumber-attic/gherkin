using System;
using System.Linq;

namespace Gherkin.Ast
{
	public interface IHasLocation
	{
		Location Location { get; }
	}
}