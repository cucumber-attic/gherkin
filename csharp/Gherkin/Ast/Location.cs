using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class Location
	{
		public string FilePath { get; private set; }
		public int Line { get; private set; }
		public int Column { get; private set; }

		public Location(string filePath, int line = 0, int column = 0)
		{
			FilePath = filePath;
			Line = line;
			Column = column;
		}
	}
}