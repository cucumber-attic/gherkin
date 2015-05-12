package minicuke;

import pickles.PickleStep;

import java.util.List;

public interface StepDefinition {
    boolean matches(PickleStep pickleStep);

    void run(List<?> arguments);

    List<String> matchedArguments(String text);
}
