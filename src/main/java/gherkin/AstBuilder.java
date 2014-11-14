package gherkin;

import gherkin.ast.AstNode;
import gherkin.ast.Background;
import gherkin.ast.DataTable;
import gherkin.ast.DocString;
import gherkin.ast.EmptyStepArgument;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.Location;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioDefinition;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.ast.StepArgument;
import gherkin.ast.TableCell;
import gherkin.ast.TableRow;
import gherkin.ast.Tag;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

import static gherkin.Parser.IAstBuilder;
import static gherkin.Parser.RuleType;
import static gherkin.Parser.TokenType;
import static gherkin.StringUtils.join;

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
                if (stepArg == null) {
                    stepArg = node.getSingle(RuleType.DocString, null);
                    if (stepArg == null) {
                        stepArg = new EmptyStepArgument();
                    }
                }
                return new Step(getLocation(stepLine, 0), stepLine.MatchedKeyword, stepLine.MatchedText, stepArg);
            }
            case DocString: {
                Token separatorToken = node.getTokens(TokenType.DocStringSeparator).get(0);
                String contentType = separatorToken.MatchedText;
                List<Token> lineTokens = node.getTokens(TokenType.Other);
                String content = join(new StringUtils.ToString<Token>() {
                    @Override
                    public String toString(Token token) {
                        return token.MatchedText;
                    }
                }, "\n", lineTokens);
                return new DocString(getLocation(separatorToken, 0), contentType, content);
            }
            case DataTable: {
                List<TableRow> rows = getTableRows(node);
                return new DataTable(rows);
            }
            case Background: {

            }
            case Scenario_Definition: {
                List<Tag> tags = getTags(node);
                AstNode scenarioNode = node.getSingle(RuleType.Scenario, null);

                if (scenarioNode != null) {
                    Token scenarioLine = scenarioNode.getToken(TokenType.ScenarioLine);
                    String description = getDescription(scenarioNode);
                    List<Step> steps = getSteps(scenarioNode);

                    return new Scenario(tags, getLocation(scenarioLine, 0), scenarioLine.MatchedKeyword, scenarioLine.MatchedText, description, steps);
                } else {
                    AstNode scenarioOutlineNode = node.getSingle(RuleType.ScenarioOutline, null);
                    Token scenarioOutlineLine = scenarioOutlineNode.getToken(TokenType.ScenarioLine);
                    String description = getDescription(scenarioOutlineNode);
                    List<Step> steps = getSteps(scenarioOutlineNode);

                    List<Examples> examplesList = scenarioOutlineNode.getItems(RuleType.Examples);

                    return new ScenarioOutline(tags, getLocation(scenarioOutlineLine, 0), scenarioOutlineLine.MatchedKeyword, scenarioOutlineLine.MatchedText, description, steps, examplesList);

                }
            }
            case Examples: {

            }
            case Description: {
                List<Token> lineTokens = node.getTokens(TokenType.Other);
                StringBuilder sb = new StringBuilder();
                for (Token lineToken : lineTokens) {
                    sb.append(lineToken.MatchedText).append("\n");
                }
                return sb.toString();
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

        }
        return node;
    }

    private List<TableRow> getTableRows(AstNode node) {
        List<TableRow> rows = new ArrayList<TableRow>();
        for (Token token : node.getTokens(TokenType.TableRow)) {
            rows.add(new TableRow(getLocation(token, 0), getCells(token)));
        }
        ensureCellCount(rows);
        return rows;
    }

    private void ensureCellCount(List<TableRow> rows) {
        if (rows.isEmpty()) return;

        int cellCount = rows.get(0).getCells().size();
        for (TableRow row : rows) {
            if (row.getCells().size() != cellCount) {
                throw new ParserException.AstBuilderException("inconsistent cell count within the table", row.getLocation());
            }
        }
    }

    private List<TableCell> getCells(Token token) {
        List<TableCell> cells = new ArrayList<TableCell>();
        for (GherkinLineSpan cellItem : token.MathcedItems) {
            cells.add(new TableCell(getLocation(token, cellItem.Column), cellItem.Text));
        }
        return cells;
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
