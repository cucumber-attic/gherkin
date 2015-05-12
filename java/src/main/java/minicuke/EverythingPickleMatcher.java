package minicuke;

import pickles.Pickle;

public class EverythingPickleMatcher implements PickleMatcher {
    @Override
    public boolean matches(Pickle pickle) {
        return true;
    }
}
