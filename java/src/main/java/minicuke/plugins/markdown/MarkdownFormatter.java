package minicuke.plugins.markdown;

import com.github.rjeschke.txtmark.Processor;
import minicuke.TestCase;
import minicuke.TestListener;
import minicuke.TestStep;

/**
 * This formatter should render the entire markdown file when we run.
 * To do that we need access to the source, and that's probably best
 * handled by a different plugin interface - something that plugs into
 * the parser somewhere, or the thing that calls the parser.
 *
 * When test cases run we should be able to append JavaScript to that same file.
 * Maybe a TestCase could know about the source? That could be represented by a DOCUMENT.
 *
 * This is a bit related to pretty printing of gherkin. We need to print the doc up until a certain
 * line, then output line by line along with results. Kind of fast-forward...
 *
 * Should a Document have a list of TestCase?
 * Should a TestCase know about its Document? If so, how do we deal with random order?
 *
 * Or maybe all we should do in this class is to write out some javascript function calls
 * that will mark particular elements on an HTML page as passing/failing.
 *
 * Where is this JavaScript written? To a stream of course! Where does that stream write?
 * It depends! If this is running on some slave node, it could write to a websocket. That
 * websocket could be connected back to the master, which will write it to a .js file on disc,
 * or possibly just append it to the HTML document that was generated from the markdown.
 *
 * What if it's Cucumber Pro we're collecting data for? The slaves shouldn't have to change.
 * Maybe results are always written to a stream!
 *
 * This could be a multiplexed stream that many readers could listen to. One for markdown/html/js
 * reporting, another one for cpro, etc. Should we base results fully and wholly on streams?
 *
 * In order to make it easy to insert results (metadata, really) into the DOM, we need line numbers
 * (and possibly column numbers) in the DOM. This can be done with a post-processor that scans the
 * markdown line-by-line and adds line numbers as it finds stuff in the html. We could use ids, but
 * maybe classes is better if a single line in Markdown can end up on several HTML lines (tables)
 */
public class MarkdownFormatter implements TestListener {
    @Override
    public void testRunStarted() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void testCaseStarted(TestCase testCase) {
        String result = Processor.process("This is ***TXTMARK***");;
    }

    @Override
    public void testStepStarted(TestStep testStep) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void testStepFinished(TestStep testStep, Throwable error) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void testCaseFinished(TestCase testCase) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void testRunFinished() {
        throw new UnsupportedOperationException();
    }
}
