using System;
using System.Collections.Generic;
using System.Linq;
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
                case TokenType.EOF:
                    break;

                case TokenType.TagLine:
                    CurrentNode.AddRange(RuleType._TagLine, token.Items.Select(tv => new Tag(tv, GetLocation(token, 1 /* TODO: get item location */))));
                    break;

                case TokenType.Empty:
                {
                    CurrentNode.Add(RuleType._Other, token);
                    break;
                }

                default:
                    CurrentNode.Add((RuleType)token.MatchedType, token);
                    break;
            }
        }

        private Location GetLocation(Token token, int column = 0)
        {
            column = column == 0 ? token.Indent : column;
            return new Location("TODO", token.Line.LineNumber, column);
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
                    var stepLine = node.GetToken(TokenType.StepLine);
                    return new Step(stepLine.MatchedKeyword, stepLine.Text, new EmptyStepArgument(), GetLocation(stepLine));
                }
                case RuleType.Scenario_Base:
                {
                    var tags = new Tag[0]; //TODO

                    Token scenarioDefinitionLine;
                    AstNode scenarioDefinitionNode;

                    var scenarioNode = node.GetSingle<AstNode>(RuleType.Scenario);
                    if (scenarioNode != null)
                    {
                        scenarioDefinitionLine = scenarioNode.GetToken(TokenType.ScenarioLine);
                        scenarioDefinitionNode = scenarioNode;
                    }
                    else
                        throw new NotImplementedException();

                    var description = scenarioDefinitionNode.GetSingle<string>(RuleType.Description);
                    var steps = scenarioDefinitionNode.GetItems<Step>(RuleType.Step).ToArray();

                    return new Scenario(tags, GetLocation(scenarioDefinitionLine), scenarioDefinitionLine.MatchedKeyword, scenarioDefinitionLine.Text, description, steps);
                }
                case RuleType.Description:
                {
                    var lineTokens = node.GetTokens(TokenType.Other);
                    string description =
                        string.Join(Environment.NewLine, lineTokens.Select(lt => lt.Text))
                            .TrimEnd();
                    return description;
                }
                case RuleType.Feature_File:
                {
                    var tags = new Tag[0]; //TODO
                    var language = "en"; //TODO

                    var header = node.GetSingle<AstNode>(RuleType.Feature_Header);
                    var featureLine = header.GetToken(TokenType.FeatureLine);
                    var scenariodefinitions = node.GetItems<ScenarioDefinition>(RuleType.Scenario_Base).ToArray();
                    var description = header.GetSingle<string>(RuleType.Description);

                    return new Feature(tags, GetLocation(featureLine), language, featureLine.MatchedKeyword, featureLine.Text, description, scenariodefinitions);
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
