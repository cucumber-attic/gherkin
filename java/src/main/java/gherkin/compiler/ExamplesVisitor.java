package gherkin.compiler;

import gherkin.ast.Background;
import gherkin.ast.DataTable;
import gherkin.ast.DocString;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.ast.TableCell;
import gherkin.ast.TableRow;
import gherkin.ast.Tag;
import gherkin.ast.Visitor;
import gherkin.test.TestCase;
import gherkin.test.TestStep;

import java.util.ArrayList;
import java.util.List;

public class ExamplesVisitor implements Visitor {
    private final TestCase testCase;
    private final List<Step> outlineSteps;
    private final List<TableCell> tableCells = new ArrayList<>();
    private final List<TableCell> headerCells = new ArrayList<>();

    public ExamplesVisitor(TestCase testCase, List<Step> outlineSteps) {
        this.testCase = testCase;
        this.outlineSteps = outlineSteps;
    }

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
        if (headerCells.isEmpty()) {
            headerCells.addAll(tableCells);
        } else {
            for (Step outlineStep : outlineSteps) {
                String text = outlineStep.getName();
                int col = 0;
                for (TableCell headerCell : headerCells) {
                    TableCell valueCell = tableCells.get(col++);
                    String header = headerCell.getValue();
                    String value = valueCell.getValue();
                    text = text.replace("<" + header + ">", value);
                }
                String name = outlineStep.getKeyword() + text;
                TestStep testStep = new TestStep(name, outlineStep, tableRow);
                testCase.addTestStep(testStep);
            }
        }
        tableCells.clear();
    }

    @Override
    public void visitTableCell(TableCell tableCell) {
        tableCells.add(tableCell);
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
