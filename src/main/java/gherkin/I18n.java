package gherkin;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

// https://github.com/cucumber/gherkin/blob/edc33ad76746e27e7050a63e30315e308731ee33/tasks/compile.rake
public class I18n {
    private Map<String, List> keywords() {
        Map<String, List> keywords = new HashMap<String, List>();
        ResourceBundle keywordBundle = ResourceBundle.getBundle("gherkin.I18nKeywords", Locale.US); // locale shouldn't matter.
        Enumeration<String> keys = keywordBundle.getKeys();
        while (keys.hasMoreElements()) {
            List<String> keywordList = new ArrayList<String>();
            String key = keys.nextElement();

            String value = keywordBundle.getString(key);
            keywordList.addAll(Arrays.asList(value.split("\\|")));
            keywords.put(key, Collections.unmodifiableList(keywordList));
        }
        return keywords;
    }
}
