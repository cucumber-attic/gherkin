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
            CurrentNode.Add((RuleType)token.MatchedType, token);
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
            return CurrentNode.GetSingle<Feature>(RuleType.Feature);
        }
        
        private object GetTransformedNode(AstNode node)
        {
            switch (node.RuleType)
            {
                case RuleType.Step:
                {
                    var stepLine = node.GetToken(TokenType.StepLine);
                    var stepArg = node.GetSingle<StepArgument>(RuleType.DataTable) ??
                                  node.GetSingle<StepArgument>(RuleType.DocString) ??
                                  new EmptyStepArgument();
                    return new Step(GetLocation(stepLine), stepLine.MatchedKeyword, stepLine.MatchedText, stepArg);
                }
                case RuleType.DocString:
                {
                    var separatorToken = node.GetTokens(TokenType.DocStringSeparator).First();
                    var contentType = separatorToken.MatchedText;
                    var lineTokens = node.GetTokens(TokenType.Other);
                    var content = string.Join(Environment.NewLine, lineTokens.Select(lt => lt.MatchedText));
        
                    return new DocString(GetLocation(separatorToken), contentType, content);
                }
                case RuleType.DataTable:
                {
                    var rows = GetTableRows(node);
                    return new DataTable(rows);
                }
                case RuleType.Background:
                {
                    var backgroundLine = node.GetToken(TokenType.BackgroundLine);
                    var description = GetDescription(node);
                    var steps = GetSteps(node);
                    return new Background(GetLocation(backgroundLine), backgroundLine.MatchedKeyword, backgroundLine.MatchedText, description, steps);
                }
                case RuleType.Scenario_Definition:
                {
                    var tags = GetTags(node);

                    var scenarioNode = node.GetSingle<AstNode>(RuleType.Scenario);
                    if (scenarioNode != null)
                    {
                        var scenarioLine = scenarioNode.GetToken(TokenType.ScenarioLine);

                        var description = GetDescription(scenarioNode);
                        var steps = GetSteps(scenarioNode);

                        return new Scenario(tags, GetLocation(scenarioLine), scenarioLine.MatchedKeyword, scenarioLine.MatchedText, description, steps);
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

                        return new ScenarioOutline(tags, GetLocation(scenarioOutlineLine), scenarioOutlineLine.MatchedKeyword, scenarioOutlineLine.MatchedText, description, steps, examples);
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
                    return new Examples(tags, GetLocation(examplesLine), examplesLine.MatchedKeyword, examplesLine.MatchedText, description, header, rows);
                }
                case RuleType.Description:
                {
                    var lineTokens = node.GetTokens(TokenType.Other);

                    // we need to trim tailing empty lines
                    lineTokens = lineTokens.Reverse().SkipWhile(t => t.Line.IsEmpty()).Reverse();

                    return string.Join(Environment.NewLine, lineTokens.Select(lt => lt.MatchedText));
                }
                case RuleType.Feature:
                {
                    var header = node.GetSingle<AstNode>(RuleType.Feature_Header);
                    var tags = GetTags(header);
                    var featureLine = header.GetToken(TokenType.FeatureLine);
                    var background = node.GetSingle<Background>(RuleType.Background);
                    var scenariodefinitions = node.GetItems<ScenarioDefinition>(RuleType.Scenario_Definition).ToArray();
                    var description = GetDescription(header);
                    var language = featureLine.MatchedGherkinDialect.Language;

                    return new Feature(tags, GetLocation(featureLine), language, featureLine.MatchedKeyword, featureLine.MatchedText, description, background, scenariodefinitions);
                }
            }

            return node;
        }

        private Location GetLocation(Token token, int column = 0)
        {
            column = column == 0 ? token.MatchedIndent + 1 : column;
            return new Location(token.Line.LineNumber, column);
        }

        private Tag[] GetTags(AstNode node)
        {
            var tagsNode = node.GetSingle<AstNode>(RuleType.Tags);
            if (tagsNode == null)
                return new Tag[0];

            return tagsNode.GetTokens(TokenType.TagLine)
                .SelectMany(t => t.MathcedItems, (t, tagItem) =>
                    new Tag(GetLocation(t, tagItem.Column), tagItem.Text))
                .ToArray();
        }

        private TableRow[] GetTableRows(AstNode node)
        {
            var rows = node.GetTokens(TokenType.TableRow).Select(token => new TableRow(GetLocation(token), GetCells(token))).ToArray();
            EnsureCellCount(rows);
            return rows;
        }

        private void EnsureCellCount(TableRow[] rows)
        {
            if (rows.Length == 0)
                return;

            int cellCount = rows[0].Cells.Count();
            foreach (var row in rows)
            {
                if (row.Cells.Count() != cellCount)
                {
                    throw new AstBuilderException("inconsistent cell count within the table", row.Location);
                }
            }
        }

        private TableCell[] GetCells(Token tableRowToken)
        {
            return tableRowToken.MathcedItems
                .Select(cellItem => new TableCell(GetLocation(tableRowToken, cellItem.Column), cellItem.Text))
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
