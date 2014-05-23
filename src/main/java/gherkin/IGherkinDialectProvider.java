package gherkin;

public interface IGherkinDialectProvider {
    public GherkinDialect getDefaultDialect();

    GherkinDialect GetDialect(String language) throws NotSupportedException;
}
