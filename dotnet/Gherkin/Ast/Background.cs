using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public class Background : ScenarioDefinition
    {
        public Background(Location location, string keyword, string name, string description, Step[] steps)
            : base(location, keyword, name, description, steps)
        {
        }
    }
}