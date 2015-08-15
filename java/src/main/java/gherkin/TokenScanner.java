package gherkin;

import gherkin.ast.Location;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;

/**
 * <p>
 * The scanner reads a gherkin doc (typically read from a .feature file) and creates a token 
 * for each line. The tokens are passed to the parser, which outputs an AST (Abstract Syntax Tree).</p>
 *
 * <p>
 * If the scanner sees a # language header, it will reconfigure itself dynamically to look for 
 * Gherkin keywords for the associated language. The keywords are defined in gherkin-languages.json.</p>
 */
public class TokenScanner implements Parser.ITokenScanner {

    private final BufferedReader reader;
    private int lineNumber;

    public TokenScanner(String source) {
        this(new StringReader(source));
    }

    public TokenScanner(Reader source) {
        this.reader = new BufferedReader(source);
    }

    @Override
    public Token read() throws IOException {
        String line = reader.readLine();
        Location location = new Location(++lineNumber, 0);
        if(line == null) {
            return new Token(null, location);
        }
        return new Token(new GherkinLine(line), location);
    }
}
