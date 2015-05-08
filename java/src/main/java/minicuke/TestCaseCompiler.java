package minicuke;

import pickles.Pickle;
import pickles.PickleStep;

import java.util.ArrayList;
import java.util.List;

public class TestCaseCompiler {
    private final List<StepDefinition> stepDefinitions;
    private final List<Hook> beforeHooks;
    private final List<Hook> afterHooks;

    public TestCaseCompiler(List<StepDefinition> stepDefinitions, List<Hook> beforeHooks, List<Hook> afterHooks) {
        this.stepDefinitions = stepDefinitions;
        this.beforeHooks = beforeHooks;
        this.afterHooks = afterHooks;
    }

    public List<TestCase> compile(List<Pickle> pickles) {
        List<TestCase> result = new ArrayList<>();
        for (Pickle pickle : pickles) {
            result.add(compile(pickle));
        }
        return result;
    }

    private TestCase compile(Pickle pickle) {
        List<TestStep> testSteps = new ArrayList<>();
        addMatchingHooks(pickle, testSteps, beforeHooks);
        for (PickleStep pickleStep : pickle.getSteps()) {
            testSteps.add(compile(pickleStep));
        }
        addMatchingHooks(pickle, testSteps, afterHooks);
        return new TestCase(testSteps);
    }

    private PickleTestStep compile(PickleStep pickleStep) {
        List<StepDefinition> matchingStepDefinitions = new ArrayList<>();
        for (StepDefinition stepDefinition : stepDefinitions) {
            if (stepDefinition.matches(pickleStep)) {
                matchingStepDefinitions.add(stepDefinition);
            }
        }
        return new PickleTestStep(pickleStep, matchingStepDefinitions);
    }

    private void addMatchingHooks(Pickle pickle, List<TestStep> testSteps, List<Hook> hooks) {
        for (Hook beforeHook : hooks) {
            if (beforeHook.matches(pickle)) {
                testSteps.add(beforeHook);
            }
        }
    }
}
