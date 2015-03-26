package pickles;

import java.util.List;

public interface TestCase {
    String getName();

    List<? extends TestStep> getTestSteps();

    List<? extends Location> getSource();
}
