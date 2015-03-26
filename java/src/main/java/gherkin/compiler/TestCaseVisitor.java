package gherkin.compiler;

import gherkin.test.TestCase;
import gherkin.test.TestStep;

public interface TestCaseVisitor {
    void visitTestCaseCollection(TestCaseCollection testCaseCollection);

    void visitTestCase(TestCase testCase);

    void visitTestStep(TestStep testStep);
}
