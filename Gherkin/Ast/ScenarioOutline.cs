using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public class ScenarioOutline : ScenarioDefinition
    {
        public IEnumerable<Examples> Examples { get; private set; }

        public ScenarioOutline(Tag[] tags, Location location, string keyword, string name, string description, Step[] steps, Examples[] examples) 
            : base(tags, location, keyword, name, description, steps)
        {
            Examples = examples;
        }
    }
}