package gherkin.compiler;

import pickles.Argument;

public class PickledDocString implements Argument {
    private final String content;

    public PickledDocString(String content) {
        this.content = content;
    }
}
