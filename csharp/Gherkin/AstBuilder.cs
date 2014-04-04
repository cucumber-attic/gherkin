using System;
using System.Collections.Generic;
using System.Linq;
using Gherkin.Ast;

namespace Gherkin
{
    public class AstBuilder : IAstBuilder
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
                case TokenType.Empty:
                {
					// we register the empty tokens as "Other" - this should have been done by the parser...
                    CurrentNode.Add(RuleType._Other, token);
                    break;
                }

                default:
                    CurrentNode.Add((RuleType)token.MatchedType, token);
                    break;
            }
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

		public object GetResult()
		{
			return CurrentNode.GetSingle<Feature>(RuleType.Feature_File);
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
					var tags = GetTags(node);

                    var scenarioNode = node.GetSingle<AstNode>(RuleType.Scenario);
	                if (scenarioNode != null)
	                {
		                var scenarioLine = scenarioNode.GetToken(TokenType.ScenarioLine);

						var description = GetDescription(scenarioNode);
						var steps = GetSteps(scenarioNode);

						return new Scenario(tags, GetLocation(scenarioLine), scenarioLine.MatchedKeyword, scenarioLine.Text, description, steps);
					}
	                else
	                {
						var scenarioOutlineNode = node.GetSingle<AstNode>(RuleType.ScenarioOutline);
						if (scenarioOutlineNode == null)
							throw new InvalidOperationException("Internal gramar error");
						var scenarioOutlineLine = scenarioOutlineNode.GetToken(TokenType.ScenarioOutlineLine);

						var description = GetDescription(scenarioOutlineNode);
						var steps = GetSteps(scenarioOutlineNode);
						var examples = scenarioOutlineNode.GetItems<Examples>(RuleType.Examples).ToArray();

		                return new ScenarioOutline(tags, GetLocation(scenarioOutlineLine), scenarioOutlineLine.MatchedKeyword, scenarioOutlineLine.Text, description, steps, examples);
					}
                }
				case RuleType.Examples:
	            {
					var tags = GetTags(node);
					var examplesLine = node.GetToken(TokenType.ExamplesLine);
					var description = GetDescription(node);

		            var allRows = GetTableRows(node);
		            var header = allRows.First();
		            var rows = allRows.Skip(1).ToArray();
		            return new Examples(tags, GetLocation(examplesLine), examplesLine.MatchedKeyword, examplesLine.Text, description, header, rows);
	            }
                case RuleType.Description:
                {
                    var lineTokens = node.GetTokens(TokenType.Other);
                    string description =
                        string.Join(Environment.NewLine, lineTokens.Select(lt => lt.Text))
                            .TrimEnd();
                    return string.IsNullOrWhiteSpace(description) ? null : description;
                }
                case RuleType.Feature_File:
	            {
                    var language = "en"; //TODO

                    var header = node.GetSingle<AstNode>(RuleType.Feature_Header);
					var tags = GetTags(header);
					var featureLine = header.GetToken(TokenType.FeatureLine);
                    var scenariodefinitions = node.GetItems<ScenarioDefinition>(RuleType.Scenario_Base).ToArray();
                    var description = GetDescription(header);

                    return new Feature(tags, GetLocation(featureLine), language, featureLine.MatchedKeyword, featureLine.Text, description, scenariodefinitions);
                }
            }

            return node;
        }

	    private Location GetLocation(Token token, int column = 0)
	    {
		    column = column == 0 ? token.Indent : column;
		    return new Location("TODO", token.Line.LineNumber + 1, column);
	    }

	    private Tag[] GetTags(AstNode node)
	    {
		    var tagsNode = node.GetSingle<AstNode>(RuleType.Tags);
			if (tagsNode == null)
				return new Tag[0];

		    return tagsNode.GetTokens(TokenType.TagLine)
				.SelectMany(t => t.Items, (t, tagName) => 
					new Tag(tagName, GetLocation(t, 0 /* TODO */)))
				.ToArray();
	    }

	    private TableRow[] GetTableRows(AstNode node)
	    {
		    return node.GetTokens(TokenType.TableRow).Select(token => new TableRow(GetLocation(token), GetCells(token))).ToArray();
	    }

	    private TableCell[] GetCells(Token tableRowToken)
	    {
		    return tableRowToken.Items
				.Select(i => new TableCell(i, GetLocation(tableRowToken, 0 /*TODO*/)))
				.ToArray();
	    }

	    private static Step[] GetSteps(AstNode scenarioDefinitionNode)
	    {
		    return scenarioDefinitionNode.GetItems<Step>(RuleType.Step).ToArray();
	    }

	    private static string GetDescription(AstNode scenarioDefinitionNode)
	    {
		    return scenarioDefinitionNode.GetSingle<string>(RuleType.Description);
	    }
    }
}
