package gherkin.markdown;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class PatternsReader {
    public List<Pattern> read(Reader reader) throws IOException {
        List<Pattern> result = new ArrayList<>();
        BufferedReader bufferedReader = new BufferedReader(reader);
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            Pattern pattern = Pattern.compile(line.substring(1, line.length() - 1));
            result.add(pattern);
        }
        return result;
    }
}
