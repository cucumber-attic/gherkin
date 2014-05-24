package gherkin;

import org.junit.Ignore;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;

public class TokenMatcherTest {

    private final TokenMatcher tokenMatcher = new TokenMatcher();
    private TokenScanner scanner;

    @Test
    @Ignore
    public void scans_feature() throws IOException {
        String source = "Feature: Minimal\n" +
                "\n" +
                "  Scenario: minimalistic\n" +
                "    Given the minimalism\n";
        scanner = new TokenScanner(source);
        assertEquals("(1:1)FeatureLine:Feature/Minimal/", read().toString());
        assertEquals("(2:1)Empty://", scanner.Read().toString());
        assertEquals("(3:3)ScenarioLine:Scenario/minimalistic/", scanner.Read().toString());
        assertEquals("(4:5)StepLine:Given /the minimalism/", scanner.Read().toString());
        assertEquals("EOF", scanner.Read().toString());
    }

    private Token read() throws IOException {
        Token token = scanner.Read();
//        tokenMatcher.match(token);
        return token;
    }

    @Test
    @Ignore
    public void scans_tags_with_trailing_space() throws IOException {
        String source = "   @tag1   @tag2    @tag3   \n";
        TokenScanner scanner = new TokenScanner(source);
        assertEquals("(1:4)TagLine://4:@tag1,12:@tag2,21:@tag3", scanner.Read().toString());
    }

    @Test
    @Ignore
    public void scans_tags_without_trailing_space() throws IOException {
        String source = "   @tag1   @tag2    @tag3\n";
        TokenScanner scanner = new TokenScanner(source);
        assertEquals("(1:4)TagLine://4:@tag1,12:@tag2,21:@tag3", scanner.Read().toString());
    }

    @Test
    @Ignore
    public void scans_table_row() throws IOException {
        String source = "   | cell_1 |cell_2|  cell_3|\n";
        TokenScanner scanner = new TokenScanner(source);
        assertEquals("(1:4)TableRow://6:cell_1,14:cell_2,23:cell_3", scanner.Read().toString());
    }
}
