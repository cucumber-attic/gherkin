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

public class Compiler {
    private final TestCaseCollection testCaseCollection = new TestCaseCollection();

    public void compile(Feature feature) {
        CompilerVisitor compiler = new CompilerVisitor();
        feature.accept(compiler);
    }

    public TestCaseCollection getTestCaseCollection() {
        return testCaseCollection;
    }

    private class CompilerVisitor implements Visitor {
        private final List<Step> steps = new ArrayList<>();
        private final List<TestStep> backgroundSteps = new ArrayList<>();
        private final List<TableRow> tableRows = new ArrayList<>();
        private final List<ExamplesCompiler> examplesCompilers = new ArrayList<>();

        private TestCase testCase;

        @Override
        public void visitFeature(Feature feature) {
        }

        @Override
        public void visitBackground(Background background) {
            for (Step step : steps) {
                String name = step.getKeyword() + step.getName();
                backgroundSteps.add(new TestStep(name, step));
            }
            steps.clear();
        }

        @Override
        public void visitScenario(Scenario scenario) {
            testCase = new TestCase();
            for (TestStep backgroundStep : backgroundSteps) {
                testCase.addTestStep(backgroundStep);
            }
            for (Step step : steps) {
                String name = step.getKeyword() + step.getName();
                testCase.addTestStep(new TestStep(name, step));
            }
            steps.clear();
            testCaseCollection.addTestCase(testCase);
        }

        @Override
        public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
            for (ExamplesCompiler examplesCompiler : examplesCompilers) {
                examplesCompiler.compile(backgroundSteps, steps, testCaseCollection);
            }
            steps.clear();
        }

        @Override
        public void visitExamples(Examples examples) {
            ExamplesCompiler examplesCompiler = new ExamplesCompiler(examples);
            examplesCompilers.add(examplesCompiler);
        }

        @Override
        public void visitStep(Step step) {
            steps.add(step);
        }

        @Override
        public void visitTag(Tag tag) {
        }

        @Override
        public void visitTableRow(TableRow tableRow) {
            tableRows.add(tableRow);
        }

        @Override
        public void visitTableCell(TableCell tableCell) {
        }

        @Override
        public void visitDocString(DocString docString) {
        }

        @Override
        public void visitDataTable(DataTable dataTable) {
        }
    }

}
