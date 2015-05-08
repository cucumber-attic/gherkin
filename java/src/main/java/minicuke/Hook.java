package minicuke;

import pickles.Pickle;

public class Hook implements TestStep {
    private final PickleMatcher pickleMatcher;

    public Hook(PickleMatcher pickleMatcher) {
        this.pickleMatcher = pickleMatcher;
    }

    public boolean matches(Pickle pickle) {
        return pickleMatcher.matches(pickle);
    }

    @Override
    public void run(TestListener testListener) {
        throw new UnsupportedOperationException();
    }

    @Override
    public StackTraceElement[] getStackTrace() {
        throw new UnsupportedOperationException();
    }
}
