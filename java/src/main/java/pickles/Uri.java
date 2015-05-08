package pickles;

import gherkin.Parser;

public class Uri {
    private final String fileName;
    private final int offset;
    private final String declaringClassForStackTrace;
    private final String methodNameForStackTrace;

    public static Uri fromThisMethod(int offset) {
        StackTraceElement stackTraceElement = Thread.currentThread().getStackTrace()[2];
        return new Uri(stackTraceElement.getFileName(), stackTraceElement.getLineNumber() + offset, stackTraceElement.getClassName(), stackTraceElement.getMethodName());
    }

    public static Uri fromFileName(String fileName) {
        return new Uri(fileName, 0, Parser.class.getName(), "parse");
    }

    private Uri(String fileName, int offset, String declaringClassForStackTrace, String methodNameForStackTrace) {
        this.fileName = fileName;
        this.offset = offset;
        this.declaringClassForStackTrace = declaringClassForStackTrace;
        this.methodNameForStackTrace = methodNameForStackTrace;
    }

    public StackTraceElement createStackTraceElement(PickleLocation pickleLocation) {
        return new StackTraceElement(declaringClassForStackTrace, methodNameForStackTrace, fileName, pickleLocation.getLine() + offset);
    }
}
