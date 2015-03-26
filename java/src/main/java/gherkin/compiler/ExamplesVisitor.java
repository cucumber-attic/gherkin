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
    private final TestCaseCollection testCaseCollection;
    private final List<Step> steps;
    private final List<TableCell> tableCells = new ArrayList<>();
    private final List<TableCell> headerCells = new ArrayList<>();

    public ExamplesVisitor(List<Step> steps, TestCaseCollection testCaseCollection) {
        this.steps = steps;
        this.testCaseCollection = testCaseCollection;
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
            TestCase testCase = new TestCase();
            for (Step step : steps) {
                String text = step.getName();
                int col = 0;
                for (TableCell headerCell : headerCells) {
                    TableCell valueCell = tableCells.get(col++);
                    String header = headerCell.getValue();
                    String value = valueCell.getValue();
                    text = text.replace("<" + header + ">", value);
                }
                String name = step.getKeyword() + text;
                TestStep testStep = new TestStep(name, step, tableRow);
                testCase.addTestStep(testStep);
            }
            testCaseCollection.addTestCase(testCase);
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
