package gherkin;

public class AstBuilder implements Parser.IAstBuilder {
    @Override
    public void Build(Token token) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void StartRule(Parser.RuleType ruleType) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void EndRule(Parser.RuleType ruleType) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Object GetResult() {
        throw new UnsupportedOperationException();
    }
}
