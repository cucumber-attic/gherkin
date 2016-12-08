using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin.Pickles
{
    public class PickleLocation
    {
        public string Path { get; private set; }
        public int Line { get; private set; }
        public int Column { get; private set; }

        public PickleLocation(string path, int line, int column)
        {
            Path = path;
            Line = line;
            Column = column;
        }
    }
}
