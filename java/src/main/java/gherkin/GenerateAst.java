package gherkin;

import gherkin.ast.Feature;
import gherkin.deps.com.google.gson.Gson;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

public class GenerateAst {
    public static void main(String[] args) throws IOException {
        Gson gson = new Gson();
        Parser<Feature> parser = new Parser<>();

        for (String fileName : args) {
            InputStreamReader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
            try {
                Feature feature = parser.parse(in);
                System.out.println(gson.toJson(feature));
            } catch (ParserException e) {
                System.err.println(e.getMessage());
                System.exit(1);
            }
        }
    }

}
