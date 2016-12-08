using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin.Pickles
{
    public class Pickle
    {
        public string Name { get; private set; }
        public IEnumerable<PickleStep> Steps { get; private set; }
        public IEnumerable<PickleTag> Tags { get; private set; }
        public IEnumerable<PickleLocation> Locations { get; private set; }

        public Pickle(string name, IEnumerable<PickleStep> steps, IEnumerable<PickleTag> tags, IEnumerable<PickleLocation> locations)
        {
            Name = name;
            Steps = steps;
            Tags = tags;
            Locations = locations;
        }
    }
}
