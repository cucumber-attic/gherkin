package gherkin.ast;

import java.util.List;

public interface HasAbstractSteps {
    List<? extends AbstractStep> getSteps();
}
