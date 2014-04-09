using System;
using System.Linq;
using System.Text;
using Gherkin.Ast;

namespace Gherkin.Specs
{
    public class TestAstFormatter
    {
		public bool IncludePositions { get; set; }

        public string FormatAst(Feature feature)
        {
            var result = new StringBuilder();
            FormatFeature(feature, result);
            return LineEndingHelper.NormalizeLineEndings(result.ToString());
        }

        private void FormatScenarioDefinition(ScenarioDefinition scenarioDefinition, StringBuilder result)
        {
            FormatTags(scenarioDefinition, result);
            FormatHasDescription(scenarioDefinition, result);
            FormatHasSteps(scenarioDefinition, result);
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

	    private void FormatHasSteps(IHasSteps hasSteps, StringBuilder result)
	    {
		    foreach (var step in hasSteps.Steps)
			    FormatStep(step, result);
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
			FormatHasLocation(tableRow, result);
		    foreach (var tableCell in tableRow.Cells)
		    {
			    result.Append("|");
				FormatHasLocation(tableCell, result);
			    result.Append(tableCell.Value);
		    }
			result.AppendLine("|");
		}

	    private void FormatTags(IHasTags hasTags, StringBuilder result)
	    {
			if (!hasTags.Tags.Any())
				return;
		    bool first = true;
		    foreach (var tag in hasTags.Tags)
		    {
			    if (!first)
				    result.Append(" ");
			    first = false;
				FormatHasLocation(tag, result);
			    result.Append(tag.Value);
		    }
		    result.AppendLine();
	    }

	    private const string INDENT = "  ";

        private void FormatStep(Step step, StringBuilder result)
        {
            result.Append(INDENT);
			FormatHasLocation(step, result);
            result.Append(step.Keyword);
            result.Append(step.Value);
            result.AppendLine();
        }

        public void FormatFeature(Feature feature, StringBuilder result)
        {
			FormatTags(feature, result);
			FormatHasDescription(feature, result);
            result.AppendLine();

	        if (feature.Background != null)
		        FormatBackground(feature.Background, result);

			foreach (var scenarioDefinition in feature.ScenarioDefinitions)
            {
                FormatScenarioDefinition(scenarioDefinition, result);
            }
        }

	    private void FormatBackground(Background background, StringBuilder result)
	    {
		    FormatHasDescription(background, result);
			FormatHasSteps(background, result);
			result.AppendLine();
	    }

	    private void FormatHasDescription(IHasDescription hasDescription, StringBuilder result)
        {
	        FormatHasLocation(hasDescription as IHasLocation, result);
            result.AppendFormat("{0}: {1}", hasDescription.Keyword, hasDescription.Title);
            result.AppendLine();
            if (hasDescription.Description != null)
                result.AppendLine(hasDescription.Description);
        }

	    private void FormatHasLocation(IHasLocation hasLocation, StringBuilder result)
	    {
		    if (hasLocation == null || !IncludePositions)
				return;

			result.AppendFormat("({0}:{1})", hasLocation.Location.Line, hasLocation.Location.Column);
	    }
    }
}
