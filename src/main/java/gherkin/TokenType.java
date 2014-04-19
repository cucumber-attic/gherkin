package gherkin;

public enum TokenType {
    None,
    EOF,
    Empty,
    Comment,
    TagLine,
    FeatureLine,
    BackgroundLine,
    ScenarioLine,
    ScenarioOutlineLine,
    ExamplesLine,
    StepLine,
    DocStringSeparator,
    TableRow,
    Language,
    Other,
}