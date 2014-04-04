using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gherkin.Ast;
using NUnit.Util;

namespace Gherkin.Specs
{
    public class TestAstFormatter
    {
        public string FormatAst(object ast)
        {
            var sb = new StringBuilder();
            FormatAstInternal(ast, "", sb);
            return NormalizeLineEndings(sb.ToString());
        }

        private void FormatAstNode(AstNode astNode, string indent, StringBuilder result)
        {
            var subIndent = indent + "\t";
            result.AppendLine(indent + "[" + astNode.RuleType);
            foreach (var subItem in astNode)
                FormatAstInternal(subItem, subIndent, result);
            result.AppendLine(indent + "]");
        }

        private void FormatAstInternal(object node, string indent, StringBuilder result)
        {
            if (node is AstNode)
                FormatAstNode((AstNode)node, indent, result);
            else if (node is Step)
                FormatStep((Step)node, result);
            else if (node is ScenarioDefinition)
                FormatScenarioDefinition((ScenarioDefinition) node, result);
            else if (node is Feature)
                FormatFeature((Feature)node, result);
            else
            {
                result.Append(indent);
                result.AppendLine(node.ToString());
            }
        }

        private void FormatScenarioDefinition(ScenarioDefinition scenarioDefinition, StringBuilder result)
        {
            FormatTags(scenarioDefinition, result);
            FormatHasDescription(scenarioDefinition, result);
            foreach (var step in scenarioDefinition.Steps)
                FormatStep(step, result);
			result.AppendLine();

	        var scenarioOutline = scenarioDefinition as ScenarioOutline;
	        if (scenarioOutline != null)
	        {
		        foreach (var examples in scenarioOutline.Examples)
		        {
			        FormatTags(examples, result);
			        FormatHasDescription(examples, result);
			        FormatRow(examples.Header, result);
			        FormatHasRows(examples, result);
		        }
	        }
        }

	    private void FormatHasRows(IHasRows hasRows, StringBuilder result)
	    {
		    foreach (var tableRow in hasRows.Rows)
		    {
			    FormatRow(tableRow, result);
		    }
	    }

	    private void FormatRow(TableRow tableRow, StringBuilder result)
	    {
		    result.Append(INDENT);
		    foreach (var tableCell in tableRow.Cells)
		    {
			    result.Append("|");
			    result.Append(tableCell.Value);
		    }
			result.AppendLine("|");
		}

	    private void FormatTags(IHasTags hasTags, StringBuilder result)
	    {
			if (!hasTags.Tags.Any())
				return;
		    result.AppendLine(string.Join(" ", hasTags.Tags.Select(t => t.Value)));
	    }

	    private const string INDENT = "  ";

        private void FormatStep(Step step, StringBuilder result)
        {
            result.Append(INDENT);
            result.Append(step.Keyword);
            result.Append(step.Value);
            result.AppendLine();
        }

        public void FormatFeature(Feature feature, StringBuilder result)
        {
			FormatTags(feature, result);
			FormatHasDescription(feature, result);
            result.AppendLine();
            //TODO: background
            foreach (var scenarioDefinition in feature.ScenarioDefinitions)
            {
                FormatScenarioDefinition(scenarioDefinition, result);
            }
        }

        private void FormatHasDescription(IHasDescription hasDescription, StringBuilder result)
        {
            result.AppendFormat("{0}: {1}", hasDescription.Keyword, hasDescription.Title);
            result.AppendLine();
            if (hasDescription.Description != null)
                result.AppendLine(hasDescription.Description);
        }

        internal string NormalizeLineEndings(string text)
        {
            return text.Replace("\r\n", "\n").TrimEnd('\n');
        }
    }
}
