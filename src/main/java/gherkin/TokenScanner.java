package gherkin;

import gherkin.ast.Location;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;

public class TokenScanner {

    private BufferedReader reader;
    private int lineNumber;

    public TokenScanner(String source) {
        this(new StringReader(source));
    }

    public TokenScanner(Reader source) {
        this.reader = new BufferedReader(source);
    }

    public Token read() throws IOException {
        String line = reader.readLine();
        Location location = new Location(++lineNumber, 0);
        return line == null ? new Token(null, location) : new Token(new GherkinLine(line, lineNumber), location);
    }
}
