using System;
using System.Linq;

namespace Gherkin.Ast
{
    public class Scenario : ScenarioDefinition
    {
        public Scenario(Tag[] tags, Location location, string keyword, string title, string description, Step[] steps) 
            : base(tags, location, keyword, title, description, steps)
        {
        }
    }
}