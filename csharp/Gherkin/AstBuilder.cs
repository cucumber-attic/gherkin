using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
    public class AstBuilder
    {
        private readonly Stack<AstNode> stack = new Stack<AstNode>();
        private AstNode CurrentNode { get { return stack.Peek(); } }

        public AstBuilder()
        {
            stack.Push(new AstNode(RuleType.None));
        }

        public void Build(Token token)
        {
            CurrentNode.Add(token);
        }

        public void StartRule(RuleType ruleType)
        {
            stack.Push(new AstNode(ruleType));
        }

        public void EndRule(RuleType ruleType)
        {
            var node = stack.Pop();
            CurrentNode.Add(node);
        }

        public object GetResult()
        {
            return CurrentNode.First();
        }
    }
}
