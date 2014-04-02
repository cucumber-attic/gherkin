using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gherkin.Ast;

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
            switch (token.MatchedType)
            {
                case TokenType.TagLine:
                    CurrentNode.AddRange(RuleType._TagLine, token.Items.Select(tv => new Tag(tv, GetLocation(token, 1 /* TODO: get item location */))));
                    break;


                default:
                    CurrentNode.Add((RuleType)token.MatchedType, token);
                    //CurrentNode.Add(token);
                    break;
            }
        }

        private Location GetLocation(Token token, int column = 0)
        {
            return new Location();
        }

        public void StartRule(RuleType ruleType)
        {
            stack.Push(new AstNode(ruleType));
        }

        public void EndRule(RuleType ruleType)
        {
            var node = stack.Pop();
            object transformedNode = GetTransformedNode(node);
            CurrentNode.Add(node.RuleType, transformedNode);
        }

        private object GetTransformedNode(AstNode node)
        {
            switch (node.RuleType)
            {
                case RuleType.Step:
                {
                    var stepLine = node.GetSingle<Token>(RuleType._StepLine);
                    return new Step(stepLine.MatchedKeyword, stepLine.Text, new EmptyStepArgument(), GetLocation(stepLine));
                }
            }

            return node;
        }

        public object GetResult()
        {
            return CurrentNode.First();
        }
    }
}
