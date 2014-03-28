using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
    public partial class Parser
    {
        public object Parse(TextReader reader)
        {
            return Parse(new TokenScanner(reader));
        }

        public object Parse(string sourceFile)
        {
            using (var reader = new StreamReader(sourceFile))
            {
                return Parse(new TokenScanner(reader));
            }
        }
    }
}
