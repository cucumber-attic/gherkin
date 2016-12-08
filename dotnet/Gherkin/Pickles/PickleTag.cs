using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin.Pickles
{
    public class PickleTag
    {
        public PickleLocation Location { get; private set; }
        public string Name { get; private set; }

        public PickleTag(PickleLocation location, string name)
        {
            Location = location;
            Name = name;
        }
    }
}
