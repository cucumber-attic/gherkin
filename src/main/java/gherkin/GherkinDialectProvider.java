package gherkin;

public class GherkinDialectProvider implements IGherkinDialectProvider {
    @Override
    public GherkinDialect getDefaultDialect() {
        throw new UnsupportedOperationException();
    }

    @Override
    public GherkinDialect GetDialect(String language) throws NotSupportedException {
        throw new UnsupportedOperationException();
    }
}
