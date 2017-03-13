package gherkin.pickles;

import gherkin.AstBuilder;
import gherkin.Parser;
import gherkin.ast.GherkinDocument;
import gherkin.deps.com.google.gson.Gson;
import gherkin.deps.com.google.gson.GsonBuilder;
import io.cucumber.tagexpressions.Expression;
import io.cucumber.tagexpressions.TagExpressionParser;
import org.junit.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class TagExpressionPredicateTest {
    private final Parser<GherkinDocument> parser = new Parser<>(new AstBuilder());
    private final Compiler compiler = new Compiler();
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Test
    public void compiles_a_scenario() throws IOException {
        List<Pickle> pickles = compiler.compile(parser.parse("" +
                "@grabme\n" +
                "Feature: f\n" +
                "  Scenario: s\n" +
                "    Given passing\n" +
                "  @metoo\n" +
                "  Scenario: m\n" +
                "    Given whatever\n"

        ), "features/hello.feature");

        Expression tagExpression = new TagExpressionParser().parse("@grabme and @metoo");
        PicklePredicate predicate = new TagExpressionPredicate(tagExpression);
        List<Pickle> filteredPickles = new ArrayList<>();
        for (Pickle pickle : pickles) {
            if(predicate.test(pickle)) {
                filteredPickles.add(pickle);
            }
        }
        assertEquals(1, filteredPickles.size());
        assertEquals("m", filteredPickles.get(0).getName());
    }

}
