using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public class Feature : IHasLocation, IHasDescription, IHasTags
    {
        public IEnumerable<Tag> Tags { get; private set; }
        public Location Location { get; private set; }
        public string Language { get; private set; }
        public string Keyword { get; private set; }
        public string Title { get; private set; }
        public string Description { get; private set; }
        public Background Background { get; private set; }
        public IEnumerable<ScenarioDefinition> ScenarioDefinitions { get; private set; }

        public Feature(Tag[] tags, Location location, string language, string keyword, string title, string description, Background background, ScenarioDefinition[] scenarioDefinitions)
        {
            Tags = tags;
            Location = location;
            Language = language;
            Keyword = keyword;
            Title = title;
            Description = description;
            Background = background;
            ScenarioDefinitions = scenarioDefinitions;
        }
    }
}
