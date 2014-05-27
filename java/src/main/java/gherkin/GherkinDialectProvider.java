package gherkin;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class GherkinDialectProvider implements IGherkinDialectProvider {
    @Override
    public GherkinDialect getDefaultDialect() {
        return GetDialect("en");
    }

    @Override
    public GherkinDialect GetDialect(String language) {
        try {
            Properties properties = new Properties();
            properties.load(getClass().getResourceAsStream(language + ".properties"));
            Map<String, String[]> map = new HashMap<String, String[]>();
            Enumeration<?> keys = properties.propertyNames();
            while (keys.hasMoreElements()) {
                String key = (String) keys.nextElement();
                String[] keywords = properties.getProperty(key).split("\\|");
                map.put(key, keywords);
            }
            return new GherkinDialect(map);
        } catch (IOException e) {
            throw new IllegalArgumentException(language);
        }
    }
}
