package gherkin;

import org.junit.Test;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;

public class GenerateAstTest {
    @Test
    public void parse_all_good_features() throws IOException {
        String[] args = getAllGoodTestFeatures();

        GenerateAst.main(args);
    }

    @Test(expected = ParserException.CompositeParserException.class)
    public void fail_on_inconsistent_cell_count() throws IOException {
        String[] args = {"../testdata/bad/inconsistent_cell_count.feature"};

        GenerateAst.main(args);
    }

    @Test(expected = ParserException.CompositeParserException.class)
    public void fail_on_multiple_parser_errors() throws IOException {
        String[] args = {"../testdata/bad/multiple_parser_errors.feature"};

        GenerateAst.main(args);
    }

    @Test(expected = ParserException.CompositeParserException.class)
    public void fail_on_single_parser_error() throws IOException {
        String[] args = {"../testdata/bad/single_parser_error.feature"};

        GenerateAst.main(args);
    }

    @Test(expected = NullPointerException.class)
    public void fail_on_invalid_language() throws IOException {
        String[] args = {"../testdata/bad/invalid_language.feature"};

        GenerateAst.main(args);
    }

    @Test(expected = NullPointerException.class)
    public void fail_on_unexpected_eof() throws IOException {
        String[] args = {"../testdata/bad/unexpected_eof.feature"};

        GenerateAst.main(args);
    }

    private String[] getAllGoodTestFeatures() throws IOException {
        File dir = new File("../testdata/good/");
        File[] files = dir.listFiles(new FilenameFilter() {
            @Override
            public boolean accept(File dir11, String name) {
                return name.endsWith(".feature");
            }
        });

        String[] args = new String[files.length];

        for (int index = 0; index < files.length; index++) {
            args[index] = files[index].getCanonicalPath();
        }

        return args;
    }
}
