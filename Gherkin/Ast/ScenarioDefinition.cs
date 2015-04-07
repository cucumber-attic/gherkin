using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public abstract class ScenarioDefinition : IHasLocation, IHasDescription, IHasSteps, IHasTags
    {
        public IEnumerable<Tag> Tags { get; private set; }
        public Location Location { get; private set; }
        public string Keyword { get; private set; }
        public string Name { get; private set; }
        public string Description { get; private set; }
        public IEnumerable<Step> Steps { get; private set; }

        protected ScenarioDefinition(Tag[] tags, Location location, string keyword, string name, string description, Step[] steps)
        {
            Tags = tags;
            Location = location;
            Keyword = keyword;
            Name = name;
            Description = description;
            Steps = steps;
        }
    }
}