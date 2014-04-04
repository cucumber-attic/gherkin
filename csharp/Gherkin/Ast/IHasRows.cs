using System;
using System.Linq;

namespace Gherkin.Ast
{
	public interface IHasRows
	{
		TableRow[] Rows { get; }
	}
}