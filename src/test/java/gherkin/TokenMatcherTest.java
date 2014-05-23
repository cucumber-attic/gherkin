package gherkin;

import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;

public class TokenMatcherTest {

    private final TokenMatcher tokenMatcher = new TokenMatcher();
    private TokenScanner scanner;

    @Test
    public void scans_feature() throws IOException {
        String source = "Feature: Minimal\n" +
                "\n" +
                "  Scenario: minimalistic\n" +
                "    Given the minimalism\n";
        scanner = new TokenScanner(source);
        assertEquals("(1:1)FeatureLine:Feature/Minimal/", read().toString());
        assertEquals("(2:1)Empty://", scanner.read().toString());
        assertEquals("(3:3)ScenarioLine:Scenario/minimalistic/", scanner.read().toString());
        assertEquals("(4:5)StepLine:Given /the minimalism/", scanner.read().toString());
        assertEquals("EOF", scanner.read().toString());
    }

    private Token read() throws IOException {
        Token token = scanner.read();
//        tokenMatcher.match(token);
        return token;
    }

    @Test
    public void scans_tags_with_trailing_space() throws IOException {
        String source = "   @tag1   @tag2    @tag3   \n";
        TokenScanner scanner = new TokenScanner(source);
        assertEquals("(1:4)TagLine://4:@tag1,12:@tag2,21:@tag3", scanner.read().toString());
    }

    @Test
    public void scans_tags_without_trailing_space() throws IOException {
        String source = "   @tag1   @tag2    @tag3\n";
        TokenScanner scanner = new TokenScanner(source);
        assertEquals("(1:4)TagLine://4:@tag1,12:@tag2,21:@tag3", scanner.read().toString());
    }

    @Test
    public void scans_table_row() throws IOException {
        String source = "   | cell_1 |cell_2|  cell_3|\n";
        TokenScanner scanner = new TokenScanner(source);
        assertEquals("(1:4)TableRow://6:cell_1,14:cell_2,23:cell_3", scanner.read().toString());
    }
}
