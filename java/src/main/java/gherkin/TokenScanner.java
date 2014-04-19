package gherkin;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;

public class TokenScanner {

    private BufferedReader reader;
    private int lineNumber;
    private GherkinDialect dialect = new GherkinDialect();

    public TokenScanner(String source) {
        this(new StringReader(source));
    }

    public TokenScanner(Reader source) {
        this.reader = new BufferedReader(source);
    }

    public Token read() throws IOException {
        String line = reader.readLine();
        Location location = new Location(++lineNumber);
        return new Token(line, location, dialect);
    }
}
