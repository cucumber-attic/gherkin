package gherkin;

import gherkin.ast.GherkinDocument;
import gherkin.deps.com.google.gson.Gson;
import gherkin.deps.com.google.gson.GsonBuilder;
import gherkin.pickles.Compiler;
import gherkin.pickles.Pickle;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static java.util.Arrays.asList;

public class IO {
    private final Gson gson = new GsonBuilder().create();
    private final Parser<GherkinDocument> parser = new Parser<>(new AstBuilder());
    private final TokenMatcher matcher = new TokenMatcher();
    private final Compiler compiler = new Compiler();

    private final boolean printSource;
    private final boolean printAst;
    private final boolean printPickles;

    public IO(boolean printSource, boolean printAst, boolean printPickles) {
        this.printSource = printSource;
        this.printAst = printAst;
        this.printPickles = printPickles;
    }

    public void process(Reader in, Writer out) throws IOException {
        BufferedReader lineReader = new BufferedReader(in);
        BufferedWriter lineWriter = new BufferedWriter(out);
        String line;
        while ((line = lineReader.readLine()) != null) {
            Map event = gson.fromJson(line, Map.class);
            if ("source".equals(event.get("type"))) {
                if (printSource) {
                    printEvent(lineWriter, line);
                }
                String uri = (String) event.get("uri");
                String source = (String) event.get("data");
                try {
                    GherkinDocument gherkinDocument = parser.parse(source, matcher);
                    if (printAst) {
                        printEvent(lineWriter, gson.toJson(gherkinDocument));
                    }
                    if (printPickles) {
                        printPickles(lineWriter, uri, gherkinDocument);
                    }
                } catch (ParserException e) {
                    printError(lineWriter, e, uri);
                }
            } else {
                printEvent(lineWriter, line);
            }
        }
        lineWriter.close();
    }

    private void printEvent(BufferedWriter lineWriter, String event) throws IOException {
        lineWriter.append(event);
        lineWriter.newLine();
        lineWriter.flush();
    }

    private void printError(BufferedWriter lineWriter, ParserException e, String uri) throws IOException {
        String event = gson.toJson(new Attachment(
                System.currentTimeMillis(),
                new Attachment.Source(
                        uri,
                        new Attachment.Location(
                                e.location.getLine(),
                                e.location.getColumn()
                        )
                ),
                e.getMessage()
        ));
        printEvent(lineWriter, event);
    }

    private void printPickles(BufferedWriter lineWriter, String uri, GherkinDocument gherkinDocument) throws IOException {
        List<Pickle> pickles = compiler.compile(gherkinDocument, uri);
        for (Pickle pickle : pickles) {
            printEvent(lineWriter, gson.toJson(pickle));
        }
    }

    public static void main(String[] argv) throws IOException {
        List<String> args = new ArrayList<>(asList(argv));

        boolean printSource = true;
        boolean printAst = false;
        boolean printPickles = true;

        while (!args.isEmpty()) {
            String arg = args.remove(0).trim();

            if (arg.equals("--no-source")) {
                printSource = false;
            }
            if (arg.equals("--source")) {
                printSource = true;
            }
            if (arg.equals("--no-ast")) {
                printAst = false;
            }
            if (arg.equals("--ast")) {
                printAst = true;
            }
            if (arg.equals("--no-pickles")) {
                printPickles = false;
            }
            if (arg.equals("--pickles")) {
                printPickles = true;
            }
        }

        IO io = new IO(printSource, printAst, printPickles);
        io.process(new InputStreamReader(System.in, "utf-8"), new OutputStreamWriter(System.out, "utf-8"));
    }
}
