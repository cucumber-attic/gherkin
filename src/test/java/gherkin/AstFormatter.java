package gherkin;

import gherkin.ast.Background;
import gherkin.ast.DataTable;
import gherkin.ast.DocString;
import gherkin.ast.DocStringLine;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.HasDescription;
import gherkin.ast.HasRows;
import gherkin.ast.HasSteps;
import gherkin.ast.ScenarioDefinition;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.ast.TableCell;
import gherkin.ast.TableRow;
import gherkin.ast.Tag;

import java.io.IOException;
import java.util.List;

import static java.lang.String.format;

public class AstFormatter {
    private static final CharSequence INDENT = "  ";

    public <T extends Appendable> T formatFeature(Feature feature, T result) throws IOException {
        if (!feature.getLanguage().equals("en")) {
            result.append(format("#language:%s", feature.getLanguage())).append("\n");
        }
        formatTags(feature.getTags(), result);
        formatHasDescription(feature, result);
        result.append("\n");

        if (feature.getBackground() != null) {
            formatBackground(feature.getBackground(), result);
        }

        for (ScenarioDefinition scenarioDefinition : feature.getScenarioDefinitions()) {
            formatScenarioDefinition(scenarioDefinition, result);
        }
        return result;
    }

    private <T extends Appendable> T formatBackground(Background background, T result) throws IOException {
        formatHasDescription(background, result);
        formatHasSteps(background, result);
        result.append("\n");
        return result;
    }

    private <T extends Appendable> T formatScenarioDefinition(ScenarioDefinition scenarioDefinition, T result) throws IOException {
        formatTags(scenarioDefinition.getTags(), result);
        formatHasDescription(scenarioDefinition, result);
        formatHasSteps(scenarioDefinition, result);
        result.append("\n");

        if (scenarioDefinition instanceof ScenarioOutline) {
            for (Examples examples : ((ScenarioOutline) scenarioDefinition).getExamplesList()) {
                formatExamples(examples, result);
            }
        }
        return result;
    }

    private <T extends Appendable> T formatExamples(Examples examples, T result) throws IOException {
        formatTags(examples.getTags(), result);
        formatHasDescription(examples, result);
        formatHasRows(examples, result);
        return result;
    }

    private <T extends Appendable> T formatHasSteps(HasSteps hasSteps, T result) throws IOException {
        for (Step step : hasSteps.getSteps()) {
            formatStep(step, result);
        }
        return result;
    }

    private <T extends Appendable> T formatStep(Step step, T result) throws IOException {
        result.append(INDENT);
        result.append(step.getKeyword());
        result.append(step.getName());
        result.append("\n");

        if (step.getStepArgument() instanceof DataTable) {
            DataTable dataTable = (DataTable) step.getStepArgument();
            formatHasRows(dataTable, result);
        } else if (step.getStepArgument() instanceof DocString) {
            DocString docString = (DocString) step.getStepArgument();
            formatDocString(docString, result);
        }

        return result;
    }

    private <T extends Appendable> T formatDocString(DocString docString, T result) throws IOException {
        result.append(INDENT).append("\"\"\"");
        if (docString.getContentType() != null)
            result.append(docString.getContentType());

        result.append("\n");
        for (DocStringLine line : docString.getLines()) {
            result.append(INDENT).append(line.getValue()).append("\n");
        }
        result.append(INDENT).append("\"\"\"").append("\n");
        return result;
    }

    private <T extends Appendable> T formatHasRows(HasRows hasRows, T result) throws IOException {
        for (TableRow tableRow : hasRows.getRows()) {
            formatRow(tableRow, result);
        }
        return result;
    }

    private <T extends Appendable> T formatRow(TableRow tableRow, T result) throws IOException {
        result.append(INDENT);
        for (TableCell tableCell : tableRow.getCells()) {
            result.append("|");
            result.append(tableCell.getValue());
        }
        result.append("|").append("\n");
        return result;
    }

    private <T extends Appendable> T formatTags(List<Tag> tags, T result) throws IOException {
        if (tags.isEmpty()) return result;
        boolean space = false;
        for (Tag tag : tags) {
            if (space) result.append(" ");
            space = true;
            result.append(tag.getName());
        }
        result.append("\n");
        return result;
    }

    private <T extends Appendable> T formatHasDescription(HasDescription hasDescription, T result) throws IOException {
        result.append(format("%s: %s", hasDescription.getKeyword(), hasDescription.getTitle())).append("\n");
        if (hasDescription.getDescription() != null) {
            result.append(hasDescription.getDescription()).append("\n");
        }
        return result;
    }
}
