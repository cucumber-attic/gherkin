package gherkin.ast;

public class DefaultVisitor implements Visitor {
    @Override
    public void visitFeature(Feature feature) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitBackground(Background background) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitScenario(Scenario scenario) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitExamples(Examples examples) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitStep(Step step) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitTag(Tag tag) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitTableRow(TableRow tableRow) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitTableCell(TableCell tableCell) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitDocString(DocString docString) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void visitDataTable(DataTable dataTable) {
        throw new UnsupportedOperationException();
    }
}
