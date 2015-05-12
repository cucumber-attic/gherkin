package gherkin.html;

import pickles.Pickle;
import pickles.PickleStep;

import java.util.List;

/**
 * A very simple HTML processor that annotates li elements with
 * a data-source-line attribute, pointing to the line number in the
 * original source.
 *
 * This can be used to annotate HTML produced from Markdown, but also
 * from plain Gherkin (if someone were to write a Gherkin2HTML renderer).
 */
public class HtmlAnnotator {
    public String annotate(String html, List<Pickle> pickles) {
        String[] lines = html.split("\n");
        int lineNumber = 0;

        for (Pickle pickle : pickles) {
            for (PickleStep pickleStep : pickle.getSteps()) {
                String text = pickleStep.getText();
                int pickleLineNumber = pickleStep.getSource().get(0).getLine();

                for (int l = lineNumber; l < lines.length; l++) {
                    lines[l] = lines[l].replaceAll("<li>(" + text + ")</li>", "<li data-source-line=\"" + pickleLineNumber + "\">$1</li>");
                }
            }
        }

        return String.join("\n", lines);
    }
}
