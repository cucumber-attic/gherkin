using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
    public class AstNode : List<object>
    {
        private RuleType ruleType;

        public AstNode(RuleType ruleType)
        {
            this.ruleType = ruleType;
        }

        public override string ToString()
        {
            return InternalToString("");
        }

        private string InternalToString(string indent)
        {
            var subIndent = indent + "\t";
            var result = new StringBuilder();
            result.AppendLine(indent + "[" + ruleType);
            foreach (var subItem in this)
                result.AppendLine(subItem is AstNode ? ((AstNode)subItem).InternalToString(subIndent) : (subIndent + subItem.ToString()));
            result.Append(indent + "]");
            return result.ToString();
        }
    }
}
