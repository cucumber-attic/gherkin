package gherkin.compiler;

import gherkin.ast.DefaultVisitor;
import gherkin.ast.Examples;
import gherkin.ast.Step;
import gherkin.ast.TableCell;
import gherkin.ast.TableRow;
import gherkin.test.TestCase;
import gherkin.test.TestStep;

import java.util.ArrayList;
import java.util.List;

class ExamplesCompiler {
    private final Examples examples;

    public ExamplesCompiler(Examples examples) {
        this.examples = examples;
    }

    public void compile(TestCase testCase, List<Step> outlineSteps) {
        ExamplesVisitor visitor = new ExamplesVisitor(testCase, outlineSteps);
        examples.accept(visitor);
    }

    public static class ExamplesVisitor extends DefaultVisitor {
        private final TestCase testCase;
        private final List<Step> outlineSteps;
        private final List<TableCell> tableCells = new ArrayList<>();
        private final List<TableCell> headerCells = new ArrayList<>();

        public ExamplesVisitor(TestCase testCase, List<Step> outlineSteps) {
            this.testCase = testCase;
            this.outlineSteps = outlineSteps;
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
    }
}
