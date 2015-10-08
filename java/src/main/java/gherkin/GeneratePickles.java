package gherkin;

import gherkin.ast.Feature;
import gherkin.deps.com.google.gson.Gson;
import gherkin.deps.com.google.gson.GsonBuilder;
import gherkin.pickles.Compiler;
import gherkin.pickles.Pickle;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

public class GeneratePickles {
    public static void main(String[] args) throws IOException {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        Parser<Feature> parser = new Parser<>(new AstBuilder());
        Compiler compiler = new Compiler();
        List<Pickle> pickles = new ArrayList<>();

        for (String fileName : args) {
            try {
                Reader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
                Parser.ITokenMatcher matcher = TokenMatcherFactory.createTokenMatcher(fileName);
                Feature feature = parser.parse(in, matcher);
                pickles.addAll(compiler.compile(feature, fileName));
            } catch (ParserException e) {
                System.err.println(e.getMessage());
                System.exit(1);
            }
        }
        System.out.println(gson.toJson(pickles));
    }
}
