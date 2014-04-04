using System;
using System.Linq;

namespace Gherkin.Ast
{
	public class Examples : IHasLocation, IHasDescription, IHasRows, IHasTags
	{
		public Tag[] Tags { get; private set; }
		public Location Location { get; private set; }
		public string Keyword { get; private set; }
		public string Title { get; private set; }
		public string Description { get; private set; }
		public TableRow Header { get; private set; }
		public TableRow[] Rows { get; private set; }

		public Examples(Tag[] tags, Location location, string keyword, string title, string description, TableRow header, TableRow[] rows)
		{
			Tags = tags;
			Location = location;
			Keyword = keyword;
			Title = title;
			Description = description;
			Header = header;
			Rows = rows;
		}
	}
}