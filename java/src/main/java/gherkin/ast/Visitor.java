package gherkin.ast;

public interface Visitor {
    void visitFeature(Feature feature);

    void visitBackground(Background background);

    void visitScenario(Scenario scenario);

    void visitScenarioOutline(ScenarioOutline scenarioOutline);

    void visitExamplesTable(ExamplesTable examplesTable);

    void visitStep(Step step);

    void visitExample(ExamplesTableRow examplesTableRow);
}
