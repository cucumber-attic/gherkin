package gherkin.ast;

public interface Visitor {
    void visitFeature(Feature feature);

    void visitBackground(Background background);

    void visitScenario(Scenario scenario);

    void visitScenarioOutline(ScenarioOutline scenarioOutline);

    void visitExamples(Examples examples);

    void visitStep(Step step);

    void visitTag(Tag tag);

    void visitTableRow(TableRow tableRow);

    void visitTableCell(TableCell tableCell);

    void visitDocString(DocString docString);

    void visitDataTable(DataTable dataTable);
}
