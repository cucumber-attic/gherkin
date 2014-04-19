package gherkin;

import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;

public class TokenScannerTest {
    @Test
    public void scans_feature() throws IOException {
        String source = "Feature: Minimal\n" +
                "\n" +
                "  Scenario: minimalistic\n" +
                "    Given the minimalism\n";
        TokenScanner scanner = new TokenScanner(source);
        assertEquals("(1:1)FeatureLine:Feature/Minimal/", scanner.read().toString());
        assertEquals("(2:1)Empty://", scanner.read().toString());
        assertEquals("(3:3)ScenarioLine:Scenario/minimalistic/", scanner.read().toString());
        assertEquals("(4:5)StepLine:Given /the minimalism/", scanner.read().toString());
        assertEquals("EOF", scanner.read().toString());
    }
}
