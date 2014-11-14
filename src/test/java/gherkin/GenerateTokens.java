package gherkin;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

public class GenerateTokens {
    public static void main(String[] args) throws FileNotFoundException, UnsupportedEncodingException {
        Parser parser = new Parser();
        String fileName = args[0];
        InputStreamReader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
        Parser.ITokenScanner scanner = new TokenScanner(in);
        TokenFormatterBuilder builder = new TokenFormatterBuilder();
        System.out.print(parser.Parse(scanner, new TokenMatcher(), builder));
    }
}
