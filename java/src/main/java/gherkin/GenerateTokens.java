package gherkin;

import gherkin.markdown.MarkdownTokenMatcher;
import gherkin.markdown.PatternsReader;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.regex.Pattern;

public class GenerateTokens {
    public static void main(String[] args) throws IOException {
        TokenFormatterBuilder builder = new TokenFormatterBuilder();
        Parser<String> parser = new Parser<>(builder);
        for (String fileName : args) {
            InputStreamReader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");

            Parser.ITokenMatcher matcher;
            if (fileName.endsWith(".feature")) {
                matcher = new TokenMatcher();
            } else if (fileName.endsWith(".md")) {
                PatternsReader patternsReader = new PatternsReader();
                List<Pattern> patterns = patternsReader.read(new InputStreamReader(new FileInputStream(fileName.replaceAll(".md$", ".patterns")), "UTF-8"));
                matcher = new MarkdownTokenMatcher(patterns);
            } else {
                throw new RuntimeException("Not Gherkin or Markdown: " + fileName);
            }
            String result = parser.parse(in, matcher);
            System.out.print(result);
        }
    }
}
