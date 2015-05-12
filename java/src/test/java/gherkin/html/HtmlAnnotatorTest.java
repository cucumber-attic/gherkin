package gherkin.html;

import com.github.rjeschke.txtmark.Processor;
import gherkin.MarkdownTokenMatcher;
import gherkin.Parser;
import gherkin.ast.Feature;
import gherkin.compiler.Compiler;
import org.junit.Test;
import pickles.Pickle;

import java.util.List;

import static org.junit.Assert.assertEquals;

public class HtmlAnnotatorTest {
    private final Parser<Feature> parser = new Parser<>();
    private final gherkin.compiler.Compiler compiler = new Compiler();

    @Test
    public void inserts_data_attributes_from_pickles() {
        String markdown = "" +
                "# Minimal\n" +
                "\n" +
                "## minimalistic\n" +
                "* the minimalism\n";
        Feature feature = parser.parse(markdown, new MarkdownTokenMatcher());
        List<Pickle> pickles = compiler.compile(feature);

        String html = Processor.process(markdown);
        HtmlAnnotator htmlAnnotator = new HtmlAnnotator();
        String annotatedHtml = htmlAnnotator.annotate(html, pickles);
        assertEquals("" +
                        "<h1>Minimal</h1>\n" +
                        "<h2>minimalistic</h2>\n" +
                        "<ul>\n" +
                        "<li data-source-line=\"4\">the minimalism</li>\n" +
                        "</ul>",
                annotatedHtml);
    }
}
