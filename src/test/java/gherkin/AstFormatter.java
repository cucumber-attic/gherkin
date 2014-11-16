package gherkin;

import gherkin.ast.*;

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

        if (feature.getBackground() != null) {
            formatBackground(feature.getBackground(), result);
        }

        for (ScenarioDefinition scenarioDefinition : feature.getScenarioDefinitions()) {
            formatScenarioDefinition(scenarioDefinition, result);
        }
        return result;
    }

    private <T extends Appendable> T formatScenarioDefinition(ScenarioDefinition scenarioDefinition, T result) throws IOException {
        result.append("\n");
        formatTags(scenarioDefinition.getTags(), result);
        formatHasDescription(scenarioDefinition, result);
        formatHasSteps(scenarioDefinition, result);

        if (scenarioDefinition instanceof ScenarioOutline) {
            for (Examples examples : ((ScenarioOutline) scenarioDefinition).getExamplesList()) {
                formatExamples(examples, result);
            }
        }
        return result;
    }

    private <T extends Appendable> T formatExamples(Examples examples, T result) throws IOException {
        result.append("\n");
        formatTags(examples.getTags(), result);
        formatHasDescription(examples, result);
        formatHasRows(examples, result);
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

    private <T extends Appendable> T formatBackground(Background background, T result) throws IOException {
        result.append("\n");
        formatHasDescription(background, result);
        formatHasSteps(background, result);
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
        return result;
    }

    private <T extends Appendable> T formatHasDescription(HasDescription hasDescription, T result) throws IOException {
        result.append(format("%s: %s", hasDescription.getKeyword(), hasDescription.getTitle())).append("\n");
        if (hasDescription.getDescription() != null) {
            result.append(hasDescription.getDescription()).append("\n");
        }
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
}
