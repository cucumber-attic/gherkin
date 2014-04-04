using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
    public class AstNode : List<object>
    {
        public RuleType RuleType { get; private set; }

        public AstNode(RuleType ruleType)
        {
            this.RuleType = ruleType;
        }
    }
}
