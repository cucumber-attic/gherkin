package gherkin;

import gherkin.ast.Feature;

import java.io.*;

public class GenerateAst {
    public static void main(String[] args) throws IOException {
        Parser parser = new Parser();
        String fileName = args[0];
        InputStreamReader in = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
        Parser.ITokenScanner scanner = new TokenScanner(in);
        Feature feature = (Feature) parser.Parse(scanner);
        AstFormatter formatter = new AstFormatter();
        System.out.print(formatter.formatFeature(feature, new StringBuilder()));
    }
}
