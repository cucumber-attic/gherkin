package gherkin;

import gherkin.ast.Feature;
import gherkin.deps.com.google.gson.Gson;
import gherkin.deps.com.google.gson.JsonParser;
import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class ParserTest {

    @Test
    public void parses_feature_after_parse_error() throws Exception {
        Gson gson = new Gson();
        JsonParser jsonParser = new JsonParser();
        InputStreamReader in1 = new InputStreamReader(new ByteArrayInputStream(("" +
                "# a comment\n" +
                "Feature: Foo\n" +
                "  Scenario: Bar\n" +
                "    Given x\n" +
                "      ```\n" +
                "      unclosed docstring\n").getBytes()), "UTF-8");
        InputStreamReader in2 = new InputStreamReader(new ByteArrayInputStream(("" +
                "Feature: Foo\n" +
                "  Scenario: Bar\n" +
                "    Given x\n" +
                "      \"\"\"\n" +
                "      closed docstring\n" +
                "      \"\"\"").getBytes()), "UTF-8");
        TokenMatcher matcher = new TokenMatcher();
        Parser<Feature> parser = new Parser<>(new AstBuilder());

        try {
            parser.parse(in1, matcher);
            fail("ParserException expected");
        } catch (ParserException e) {
            // pass
        }
        Feature feature = parser.parse(in2, matcher);

        assertEquals(jsonParser.parse("" +
                "{\"tags\":[]," +
                "\"language\":\"en\"," +
                "\"keyword\":\"Feature\"," +
                "\"name\":\"Foo\"," +
                "\"scenarioDefinitions\":[{" +
                "    \"tags\":[]," +
                "    \"keyword\":\"Scenario\"," +
                "    \"name\":\"Bar\"," +
                "    \"steps\":[{" +
                "        \"keyword\":\"Given \"," +
                "        \"text\":\"x\"," +
                "        \"argument\":{" +
                "            \"contentType\":\"\"," +
                "            \"content\":\"closed docstring\"," +
                "            \"type\":\"DocString\"," +
                "            \"location\":{\"line\":4,\"column\":7}}," +
                "        \"type\":\"Step\"," +
                "        \"location\":{\"line\":3,\"column\":5}}]," +
                "    \"type\":\"Scenario\"," +
                "    \"location\":{\"line\":2,\"column\":3}}]," +
                "\"comments\":[]," +
                "\"type\":\"Feature\"," +
                "\"location\":{\"line\":1,\"column\":1}}"),
                jsonParser.parse(gson.toJson(feature)));
    }

}
