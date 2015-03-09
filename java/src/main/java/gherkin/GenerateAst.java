package gherkin;

import gherkin.ast.Feature;
import gherkin.deps.com.google.gson.Gson;
import gherkin.deps.com.google.gson.GsonBuilder;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

public class GenerateAst {
    public static void main(String[] args) throws IOException {
        GsonBuilder b = new GsonBuilder();
        Gson gson = b.create();
        Parser parser = new Parser();

        for (String fileName : args) {
            InputStreamReader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
            Parser.ITokenScanner scanner = new TokenScanner(in);
            Feature feature = (Feature) parser.Parse(scanner);

            System.out.println(gson.toJson(feature));
        }
    }

}
