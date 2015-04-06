package gherkin;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

public class GenerateTokens {
    public static void main(String[] args) throws FileNotFoundException, UnsupportedEncodingException {
        Parser<String> parser = new Parser<>();
        for (String fileName : args) {
            InputStreamReader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
            TokenFormatterBuilder builder = new TokenFormatterBuilder();
            String result = parser.parse(in, builder);
            System.out.print(result);
        }
    }
}
