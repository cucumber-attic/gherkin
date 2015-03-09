package gherkin;

public interface IGherkinDialectProvider {
    public GherkinDialect getDefaultDialect();

    GherkinDialect getDialect(String language);
}
