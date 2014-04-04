using System;
using System.Linq;

namespace Gherkin.Ast
{
	public interface IHasSteps
	{
		Step[] Steps { get; }
	}
}