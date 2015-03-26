package gherkin.compiler;

import gherkin.deps.com.google.gson.Gson;
import gherkin.test.TestCase;
import gherkin.test.TestStep;

import java.util.ArrayList;
import java.util.List;

public class TestCasePrinter implements TestCaseVisitor {
    private List<TestCase> testCases = new ArrayList<>();

    @Override
    public void visitTestCaseCollection(TestCaseCollection testCaseCollection) {
    }

    @Override
    public void visitTestCase(TestCase testCase) {
        testCases.add(testCase);
    }

    @Override
    public void visitTestStep(TestStep testStep) {
    }

    public String getResult() {
        return new Gson().toJson(testCases);
    }
}
