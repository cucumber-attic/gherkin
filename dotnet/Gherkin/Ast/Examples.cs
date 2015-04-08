using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public class Examples : IHasLocation, IHasDescription, IHasRows, IHasTags
    {
        public IEnumerable<Tag> Tags { get; private set; }
        public Location Location { get; private set; }
        public string Keyword { get; private set; }
        public string Name { get; private set; }
        public string Description { get; private set; }
        public TableRow Header { get; private set; }
        public IEnumerable<TableRow> Body { get; private set; }

        public Examples(Tag[] tags, Location location, string keyword, string name, string description, TableRow header, TableRow[] body)
        {
            Tags = tags;
            Location = location;
            Keyword = keyword;
            Name = name;
            Description = description;
            Header = header;
            Body = body;
        }

        IEnumerable<TableRow> IHasRows.Rows
        {
            get { return new TableRow[] {Header}.Concat(Body); }
        }
    }
}