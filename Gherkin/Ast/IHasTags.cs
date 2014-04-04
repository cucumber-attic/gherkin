using System;
using System.Linq;

namespace Gherkin.Ast
{
	public interface IHasTags
	{
		Tag[] Tags { get; }
	}
}