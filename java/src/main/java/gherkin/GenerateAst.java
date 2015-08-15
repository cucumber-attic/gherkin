package gherkin;

import gherkin.ast.Feature;
import gherkin.deps.com.google.gson.Gson;
import gherkin.markdown.MarkdownTokenMatcher;
import gherkin.markdown.PatternsReader;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.regex.Pattern;

public class GenerateAst {
    public static void main(String[] args) throws IOException {
        Gson gson = new Gson();
        Parser<Feature> parser = new Parser<>(new AstBuilder());

        long startTime = System.currentTimeMillis();
        for (String fileName : args) {
            InputStreamReader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");

            Parser.ITokenMatcher matcher = null;
            if (fileName.endsWith(".feature")) {
                matcher = new TokenMatcher();
            } else if (fileName.endsWith(".md")) {
                PatternsReader patternsReader = new PatternsReader();
                List<Pattern> patterns = patternsReader.read(new InputStreamReader(new FileInputStream(fileName.replaceAll(".md$", ".patterns")), "UTF-8"));
                matcher = new MarkdownTokenMatcher(patterns);
            } else {
                System.err.println("Not Gherkin or Markdown: " + fileName);
                System.exit(1);
            }

            try {
                Feature feature = parser.parse(in, matcher);
                System.out.println(gson.toJson(feature));
            } catch (ParserException e) {
                System.err.println(e.getMessage());
                System.exit(1);
            }
        }
        long endTime = System.currentTimeMillis();
        if(System.getenv("GHERKIN_PERF") != null) {
            System.err.println(endTime - startTime);
        }
    }

}
