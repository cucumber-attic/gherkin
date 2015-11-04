package gherkin;

import gherkin.markdown.MarkdownTokenMatcher;
import gherkin.markdown.PatternsReader;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.regex.Pattern;

public class TokenMatcherFactory {
    static Parser.ITokenMatcher createTokenMatcher(String fileName) throws IOException {
        if (fileName.endsWith(".feature")) {
            return new TokenMatcher();
        } else if (fileName.endsWith(".md")) {
            PatternsReader patternsReader = new PatternsReader();
            String patternsFileName = fileName.replaceAll(".md$", ".patterns");
            List<Pattern> patterns = patternsReader.read(new InputStreamReader(new FileInputStream(patternsFileName), "UTF-8"));
            return new MarkdownTokenMatcher(patterns);
        } else {
            throw new RuntimeException("Not Gherkin or Markdown: " + fileName);
        }
    }
}
