package gherkin;

import gherkin.ast.GherkinDocument;
import gherkin.pickles.Compiler;
import gherkin.deps.com.google.gson.Gson;
import gherkin.pickles.Pickle;
import gherkin.deps.com.google.gson.GsonBuilder;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

public class GeneratePickles {
    public static void main(String[] args) throws IOException {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        Parser<GherkinDocument> parser = new Parser<>(new AstBuilder());
        TokenMatcher matcher = new TokenMatcher();
        Compiler compiler = new Compiler();
        List<Pickle> pickles = new ArrayList<>();

        for (String fileName : args) {
            Reader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
            try {
                GherkinDocument gherkinDocument = parser.parse(in, matcher);
                pickles.addAll(compiler.compile(gherkinDocument, fileName));
            } catch (ParserException e) {
                Stdio.err.println(e.getMessage());
                System.exit(1);
            }
        }
        Stdio.out.println(gson.toJson(pickles));
    }
}
