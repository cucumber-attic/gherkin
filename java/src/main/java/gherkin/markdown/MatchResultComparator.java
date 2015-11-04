package gherkin.markdown;

import java.util.Comparator;
import java.util.regex.MatchResult;

public class MatchResultComparator implements Comparator<MatchResult> {
    @Override
    public int compare(MatchResult left, MatchResult right) {
        return left.start() - right.start();
    }
}
