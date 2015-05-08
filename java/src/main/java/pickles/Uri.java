package pickles;

import gherkin.Parser;

public class Uri {
    private final String fileName;
    private final String declaringClassForStackTrace;
    private final String methodNameForStackTrace;

    public static Uri fromThisMethod() {
        StackTraceElement stackTraceElement = Thread.currentThread().getStackTrace()[2];
        return new Uri(stackTraceElement.getFileName(), stackTraceElement.getClassName(), stackTraceElement.getMethodName());
    }

    public static Uri fromFile(String fileName) {
        return new Uri(fileName, Parser.class.getName(), "parse");
    }

    private Uri(String fileName, String declaringClassForStackTrace, String methodNameForStackTrace) {
        this.fileName = fileName;
        this.declaringClassForStackTrace = declaringClassForStackTrace;
        this.methodNameForStackTrace = methodNameForStackTrace;
    }

    public String getFileName() {
        return fileName;
    }

    public String getDeclaringClassForStackTrace() {
        return declaringClassForStackTrace;
    }

    public String getMethodNameForStackTrace() {
        return methodNameForStackTrace;
    }
}
