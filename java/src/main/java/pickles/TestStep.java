package pickles;

import java.util.List;

public interface TestStep {
    String getName();

    List<? extends Location> getSource();

    Argument getArgument();
}
