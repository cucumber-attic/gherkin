package gherkin.pickles;

import io.cucumber.tagexpressions.Expression;

import java.util.ArrayList;
import java.util.List;

public class TagExpressionPredicate implements PicklePredicate {
    private final Expression tagExpression;

    public TagExpressionPredicate(Expression tagExpression) {
        this.tagExpression = tagExpression;
    }

    @Override
    public boolean test(Pickle pickle) {
        List<String> tagNames = new ArrayList<>();
        List<PickleTag> tags = pickle.getTags();
        for (PickleTag tag : tags) {
            tagNames.add(tag.getName());
        }
        return tagExpression.evaluate(tagNames);
    }
}
