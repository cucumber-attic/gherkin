package minicuke;

import pickles.PickleStep;

import java.util.List;

public class PickleTestStep implements TestStep {
    private final PickleStep pickleStep;
    private final List<StepDefinition> matchingStepDefinitions;

    public PickleTestStep(PickleStep pickleStep, List<StepDefinition> matchingStepDefinitions) {
        this.pickleStep = pickleStep;
        this.matchingStepDefinitions = matchingStepDefinitions;
    }

    @Override
    public void run(TestListener testListener) {
        testListener.testStepStarted(this);
        try {
            run0();
            testListener.testStepFinished(this, Status.SUCCESS);
        } catch(Throwable t) {
            testListener.testStepFinished(this, Status.FAILED);
        }
    }

    @Override
    public StackTraceElement[] getStackTrace() {
        return pickleStep.getStackTrace();
    }

    private void run0() {
        if (matchingStepDefinitions.isEmpty()) {
            throw new UndefinedStepException(pickleStep);
        }
        if (matchingStepDefinitions.size() == 1) {
            StepDefinition stepDefinition = matchingStepDefinitions.get(0);
            run(stepDefinition);
        }
        // TODO: Handle ambiguous
    }

    private void run(StepDefinition stepDefinition) {
        List<String> arguments = stepDefinition.matchedArguments(pickleStep.getText());
        // TODO - add the pickleStep's argument if it's not null.
        stepDefinition.run(arguments);
    }
}
