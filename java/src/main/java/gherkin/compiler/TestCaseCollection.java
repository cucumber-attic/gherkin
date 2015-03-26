package gherkin.compiler;

import gherkin.test.TestCase;

import java.util.ArrayList;
import java.util.List;

public class TestCaseCollection {
    private final List<TestCase> testCases = new ArrayList<>();

    public void accept(TestCaseVisitor visitor) {
        for (TestCase testCase : testCases) {
            testCase.accept(visitor);
        }
        visitor.visitTestCaseCollection(this);
    }

    public void addTestCase(TestCase testCase) {
        testCases.add(testCase);
    }
}
