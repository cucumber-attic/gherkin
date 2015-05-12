package minicuke.plugins.testresult;

import minicuke.Status;

public class TestStepResult {
    private final StackTraceElement[] stackTrace;
    private Status status;

    public TestStepResult(StackTraceElement[] stackTrace, Status status) {
        this.stackTrace = stackTrace;
        this.status = status;
    }

    public Status getStatus() {
        return status;
    }
}
