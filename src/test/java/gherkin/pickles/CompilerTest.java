package gherkin.pickles;

import gherkin.AstBuilder;
import gherkin.Parser;
import gherkin.ast.Feature;
import gherkin.deps.com.google.gson.Gson;
import gherkin.deps.com.google.gson.GsonBuilder;
import org.junit.Test;

import java.io.IOException;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class CompilerTest {
    private final Parser<Feature> parser = new Parser<>(new AstBuilder());
    private final Compiler compiler = new Compiler();
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Test
    public void compiles_a_scenario() throws IOException {
        List<Pickle> pickles = compiler.compile(parser.parse("" +
                "Feature: f\n" +
                "  Scenario: s\n" +
                "    Given passing\n"), "features/hello.feature");


        assertEquals("" +
                        "[\n" +
                        "  {\n" +
                        "    \"name\": \"Scenario: s\",\n" +
                        "    \"steps\": [\n" +
                        "      {\n" +
                        "        \"text\": \"passing\",\n" +
                        "        \"arguments\": [],\n" +
                        "        \"locations\": [\n" +
                        "          {\n" +
                        "            \"path\": \"features/hello.feature\",\n" +
                        "            \"line\": 3,\n" +
                        "            \"column\": 11\n" +
                        "          }\n" +
                        "        ]\n" +
                        "      }\n" +
                        "    ],\n" +
                        "    \"tags\": [],\n" +
                        "    \"locations\": [\n" +
                        "      {\n" +
                        "        \"path\": \"features/hello.feature\",\n" +
                        "        \"line\": 2,\n" +
                        "        \"column\": 3\n" +
                        "      }\n" +
                        "    ]\n" +
                        "  }\n" +
                        "]",
                gson.toJson(pickles));
    }
}
