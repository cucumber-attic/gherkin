package minicuke;

import pickles.PickleStep;

public class UndefinedStepException extends RuntimeException {
    public UndefinedStepException(PickleStep pickleStep) {
        super("Undefined step: " + pickleStep.getText());
        setStackTrace(pickleStep.getStackTrace());
    }
}
