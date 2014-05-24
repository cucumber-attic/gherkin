package gherkin;

public class TokenFormatterBuilder implements Parser.IAstBuilder {
    private final TestTokenFormatter formatter = new TestTokenFormatter();
    private final StringBuilder tokensTextBuilder = new StringBuilder();

    @Override
    public void Build(Token token) {
        tokensTextBuilder.append(formatter.FormatToken(token)).append("\n");
    }

    @Override
    public void StartRule(Parser.RuleType ruleType) {
    }

    @Override
    public void EndRule(Parser.RuleType ruleType) {
    }

    @Override
    public Object GetResult() {
        return tokensTextBuilder.toString();
    }
}
