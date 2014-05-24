package gherkin;

public class GherkinDialectProvider implements IGherkinDialectProvider {
    @Override
    public GherkinDialect getDefaultDialect() {
        return new GherkinDialect();
    }

    @Override
    public GherkinDialect GetDialect(String language) throws NotSupportedException {
        return getDefaultDialect();
    }
}
