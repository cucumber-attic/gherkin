package gherkin.ast;

import java.util.Map;

public class ExamplesTableRow implements DescribesItself {
    private final Map<String, String> data;

    public ExamplesTableRow(Map<String, String> data) {
        this.data = data;
    }

    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitExample(this);
    }

    public String expand(String outlineStepName) {
        String stepName = outlineStepName;
        for (Map.Entry<String, String> pair : data.entrySet()) {
            stepName = stepName.replace("<" + pair.getKey() + ">", pair.getValue());
        }
        return stepName;
    }
}
