package gherkin;

import gherkin.ast.AstNode;
import gherkin.ast.Background;
import gherkin.ast.Feature;
import gherkin.ast.Location;
import gherkin.ast.ScenarioDefinition;
import gherkin.ast.Tag;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

import static gherkin.Parser.IAstBuilder;
import static gherkin.Parser.RuleType;
import static gherkin.Parser.TokenType;

public class AstBuilder implements IAstBuilder {
    private final Deque<AstNode> stack = new ArrayDeque<AstNode>();

    public AstBuilder() {
        stack.push(new AstNode(RuleType.None));
    }

    private AstNode CurrentNode() {
        return stack.peek();
    }

    @Override
    public void Build(Token token) {
        RuleType ruleType = RuleType.cast(token.MatchedType);
        CurrentNode().add(ruleType, token);
    }

    @Override
    public void StartRule(RuleType ruleType) {
        stack.push(new AstNode(ruleType));
    }

    @Override
    public void EndRule(RuleType ruleType) {
        AstNode node = stack.pop();
        Object transformedNode = getTransformedNode(node);
        CurrentNode().add(node.ruleType, transformedNode);
    }

    private Object getTransformedNode(AstNode node) {
        switch (node.ruleType) {
            case Feature:
                AstNode header = node.getSingle(RuleType.Feature_Header, new AstNode(RuleType.Feature_Header));
                List<Tag> tags = getTags(header);
                Token featureLine = header.getToken(TokenType.FeatureLine);
                Background background = node.getSingle(RuleType.Background, null);
                List<ScenarioDefinition> scenariodefinitions = node.getItems(RuleType.Scenario_Definition);
                String description = getDescription(header);
                String language = featureLine.MatchedGherkinDialect.getLanguage();

                return new Feature(tags, getLocation(featureLine, 0), language, featureLine.MatchedKeyword, featureLine.MatchedText, description, background, scenariodefinitions);

        }
        return node;
    }

    private Location getLocation(Token token, int column) {
        return column == 0 ? token.Location : new Location(token.Location.Line, column);
    }

    private String getDescription(AstNode node) {
        return node.getSingle(RuleType.Description, "");
    }

    private List<Tag> getTags(AstNode node) {
        AstNode tagsNode = node.getSingle(RuleType.Tags, new AstNode(RuleType.None));
        if (tagsNode == null)
            return new ArrayList<Tag>();

        List<Token> tokens = tagsNode.getTokens(TokenType.TagLine);
        List<Tag> tags = new ArrayList<Tag>();
        for (Token token : tokens) {
            for (GherkinLineSpan tagItem : token.MathcedItems) {
                tags.add(new Tag(getLocation(token, tagItem.Column), tagItem.Text));
            }
        }
        return tags;
    }

    @Override
    public Object GetResult() {
        return CurrentNode().getSingle(RuleType.Feature, null);
    }
}
