using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin.Pickles
{
    public abstract class Argument
    {
        public abstract PickleLocation Location { get; }
    }
}
