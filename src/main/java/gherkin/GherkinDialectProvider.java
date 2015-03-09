package gherkin;

import gherkin.deps.com.google.gson.Gson;

import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

public class GherkinDialectProvider implements IGherkinDialectProvider {
    private static Map<String, Map<String, List<String>>> DIALECTS;

    static {
        Gson gson = new Gson();
        try {
            Reader dialects = new InputStreamReader(GherkinDialectProvider.class.getResourceAsStream("dialects.json"), "UTF-8");
            DIALECTS = gson.fromJson(dialects, Map.class);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }

    public GherkinDialect getDefaultDialect() {
        return getDialect("en");
    }

    @Override
    public GherkinDialect getDialect(String language) {
        Map<String, List<String>> map = DIALECTS.get(language);
        return new GherkinDialect(language, map);
    }
}
