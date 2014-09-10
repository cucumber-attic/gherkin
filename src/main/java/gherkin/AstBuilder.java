package gherkin;

import gherkin.ast.AstNode;
import gherkin.ast.Background;
import gherkin.ast.EmptyStepArgument;
import gherkin.ast.Feature;
import gherkin.ast.Location;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioDefinition;
import gherkin.ast.Step;
import gherkin.ast.StepArgument;
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
            case Step: {
                Token stepLine = node.getToken(TokenType.StepLine);
                StepArgument stepArg = node.getSingle(RuleType.DataTable, null);
                if(stepArg == null) {
                    stepArg = node.getSingle(RuleType.DocString, null);
                    if(stepArg == null) {
                        stepArg = new EmptyStepArgument();
                    }
                }
                return new Step(getLocation(stepLine, 0), stepLine.MatchedKeyword, stepLine.MatchedText, stepArg);
            }
            case Feature: {
                AstNode header = node.getSingle(RuleType.Feature_Header, new AstNode(RuleType.Feature_Header));
                List<Tag> tags = getTags(header);
                Token featureLine = header.getToken(TokenType.FeatureLine);
                Background background = node.getSingle(RuleType.Background, null);
                List<ScenarioDefinition> scenarioDefinitions = node.getItems(RuleType.Scenario_Definition);
                String description = getDescription(header);
                String language = featureLine.MatchedGherkinDialect.getLanguage();

                return new Feature(tags, getLocation(featureLine, 0), language, featureLine.MatchedKeyword, featureLine.MatchedText, description, background, scenarioDefinitions);
            }
            case Description: {
                List<Token> lineTokens = node.getTokens(TokenType.Other);
                StringBuilder sb = new StringBuilder();
                for (Token lineToken : lineTokens) {
                    sb.append(lineToken.MatchedText).append("\n");
                }
                return sb.toString();
            }
            case Scenario_Definition: {
                List<Tag> tags = getTags(node);
                AstNode scenarioNode = node.getSingle(RuleType.Scenario, null);

                if(scenarioNode != null) {
                    Token scenarioLine = scenarioNode.getToken(TokenType.ScenarioLine);
                    String description = getDescription(scenarioNode);
                    List<Step> steps = getSteps(scenarioNode);

                    return new Scenario(tags, getLocation(scenarioLine, 0), scenarioLine.MatchedKeyword, scenarioLine.MatchedText, description, steps);
                }
            }

        }
        return node;
    }

    private List<Step> getSteps(AstNode node) {
        return node.getItems(RuleType.Step);
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
