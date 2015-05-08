package minicuke;

import pickles.Pickle;

public class NothingPickleMatcher implements PickleMatcher {
    @Override
    public boolean matches(Pickle pickle) {
        return false;
    }
}
