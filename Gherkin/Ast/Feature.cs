using System;
using System.Linq;

namespace Gherkin.Ast
{
    public class Feature : IHasLocation, IHasDescription, IHasTags
    {
        public Tag[] Tags { get; private set; }
        public Location Location { get; private set; }
        public string Language { get; private set; }
        public string Keyword { get; private set; }
        public string Title { get; private set; }
        public string Description { get; private set; }
        public ScenarioDefinition[] ScenarioDefinitions { get; private set; }

        public Feature(Tag[] tags, Location location, string language, string keyword, string title, string description, ScenarioDefinition[] scenarioDefinitions)
        {
            Tags = tags;
            Location = location;
            Language = language;
            Keyword = keyword;
            Title = title;
            Description = description;
            ScenarioDefinitions = scenarioDefinitions;
        }
    }
}
