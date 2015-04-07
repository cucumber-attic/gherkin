using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public class Background : IHasLocation, IHasDescription, IHasSteps
    {
        public Location Location { get; private set; }
        public string Keyword { get; private set; }
        public string Name { get; private set; }
        public string Description { get; private set; }
        public IEnumerable<Step> Steps { get; private set; }

        public Background(Location location, string keyword, string name, string description, Step[] steps)
        {
            Location = location;
            Keyword = keyword;
            Name = name;
            Description = description;
            Steps = steps;
        }
    }
}