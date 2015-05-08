package minicuke;

public interface TestStep {
    void run(TestListener testListener);

    StackTraceElement[] getStackTrace();
}
