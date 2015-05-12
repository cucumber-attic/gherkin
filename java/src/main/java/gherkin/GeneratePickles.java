package gherkin;

import gherkin.ast.Feature;
import gherkin.compiler.Compiler;
import gherkin.deps.com.google.gson.Gson;
import pickles.Pickle;
import pickles.Uri;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class GeneratePickles {
    public static void main(String[] args) throws IOException {
        Gson gson = new Gson();
        Parser<Feature> parser = new Parser<>();
        Compiler compiler = new Compiler();
        List<Pickle> pickles = new ArrayList<>();

        for (String fileName : args) {
            InputStreamReader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
            try {
                Feature feature = parser.parse(in);
                pickles.addAll(compiler.compile(feature, Uri.fromFileName(fileName)));
            } catch (ParserException e) {
                System.err.println(e.getMessage());
                System.exit(1);
            }
        }
        System.out.println(gson.toJson(pickles));
    }
}
