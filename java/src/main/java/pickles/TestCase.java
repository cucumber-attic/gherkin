package pickles;

import java.util.List;

public interface TestCase {
    String getName();

    List<? extends TestStep> getPickledSteps();

    List<? extends Location> getSource();
}
