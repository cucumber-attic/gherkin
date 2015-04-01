package gherkin3

import (
	"strings"

	"github.com/cucumber/gherkin3/ast"
)

type astBuilder struct {
	stack []*astNode
}

func (t *astBuilder) getResult() *ast.Feature {
	res := t.currentNode().getSingle(RuleType_Feature)
	if val, ok := res.(*ast.Feature); ok {
		return val
	}
	return nil
}

type astNode struct {
	ruleType RuleType
	subNodes map[RuleType][]interface{}
}

func (a *astNode) add(rt RuleType, obj interface{}) {
	//fmt.Fprintf(os.Stderr, "+++ astNode:add: %s\n", rt.Name())
	a.subNodes[rt] = append(a.subNodes[rt], obj)
}

func (a *astNode) getSingle(rt RuleType) interface{} {
	if val, ok := a.subNodes[rt]; ok {
		for i := range val {
			return val[i]
		}
	}
	return nil
}

func (a *astNode) getItems(rt RuleType) []interface{} {
	var res []interface{}
	if val, ok := a.subNodes[rt]; ok {
		for i := range val {
			res = append(res, val[i])
		}
	}
	return res
}

func (a *astNode) getToken(tt TokenType) *Token {
	if val, ok := a.getSingle(tt.RuleType()).(*Token); ok {
		return val
	}
	return nil
}

func (a *astNode) getTokens(tt TokenType) []*Token {
	var items = a.getItems(tt.RuleType())
	var tokens []*Token
	for i := range items {
		if val, ok := items[i].(*Token); ok {
			tokens = append(tokens, val)
		}
	}
	return tokens
}

func (t *astBuilder) currentNode() *astNode {
	if len(t.stack) > 0 {
		return t.stack[len(t.stack)-1]
	}
	return nil
}

func NewAstNode(rt RuleType) *astNode {
	return &astNode{
		ruleType: rt,
		subNodes: make(map[RuleType][]interface{}),
	}
}

func NewAstBuilder() *astBuilder {
	builder := new(astBuilder)
	builder.push(NewAstNode(RuleType_None))
	return builder
}

func (t *astBuilder) push(n *astNode) {
	t.stack = append(t.stack, n)
}

func (t *astBuilder) pop() *astNode {
	x := t.stack[len(t.stack)-1]
	t.stack = t.stack[:len(t.stack)-1]
	return x
}

func (t *astBuilder) Build(tok *Token) (error, bool) {
	//fmt.Fprintf(os.Stderr, "+++ astBuilder:Build: %s\n", tok.String())
	t.currentNode().add(tok.Type.RuleType(), tok)
	return nil, true
}
func (t *astBuilder) StartRule(r RuleType) (error, bool) {
	//fmt.Fprintf(os.Stderr, "+++ astBuilder:StartRule: %s\n", r.Name())
	t.push(NewAstNode(r))
	return nil, true
}
func (t *astBuilder) EndRule(r RuleType) (error, bool) {
	//fmt.Fprintf(os.Stderr, "+++ astBuilder:EndRule: %s\n", r.Name())
	node := t.pop()
	transformedNode, err := t.transformNode(node)
	t.currentNode().add(node.ruleType, transformedNode)
	return err, true
}

func (t *astBuilder) transformNode(node *astNode) (interface{}, error) {
	switch node.ruleType {

	case RuleType_Step:
		stepLine := node.getToken(TokenType_StepLine)
		step := new(ast.Step)
		step.Type = "Step"
		step.Location = astLocation(stepLine)
		step.Keyword = stepLine.Keyword
		step.Name = stepLine.Text
		step.Argument = node.getSingle(RuleType_DataTable)
		if step.Argument == nil {
			step.Argument = node.getSingle(RuleType_DocString)
		}
		return step, nil

	case RuleType_DocString:
		separatorToken := node.getToken(TokenType_DocStringSeparator)
		contentType := separatorToken.Text
		lineTokens := node.getTokens(TokenType_Other)
		var text string
		for i := range lineTokens {
			if i > 0 {
				text += "\n"
			}
			text += lineTokens[i].Text
		}
		ds := new(ast.DocString)
		ds.Type = "DocString"
		ds.Location = astLocation(separatorToken)
		ds.ContentType = contentType
		ds.Content = text
		ds.Delimitter = DOCSTRING_SEPARATOR // TODO: remember separator
		return ds, nil

	case RuleType_DataTable:
		rows, err := astTableRows(node)
		dt := new(ast.DataTable)
		dt.Type = "DataTable"
		dt.Location = rows[0].Location
		dt.Rows = rows
		return dt, err

	case RuleType_Background:
		backgroundLine := node.getToken(TokenType_BackgroundLine)
		description, _ := node.getSingle(RuleType_Description).(string)
		bg := new(ast.Background)
		bg.Type = "Background"
		bg.Location = astLocation(backgroundLine)
		bg.Keyword = backgroundLine.Keyword
		bg.Name = backgroundLine.Text
		bg.Description = description
		bg.Steps = astSteps(node)
		return bg, nil

	case RuleType_Scenario_Definition:
		// List<Tag> tags = getTags(node);
		// AstNode scenarioNode = node.getSingle(RuleType.Scenario, null);
		// if (scenarioNode != null) {
		//     Token scenarioLine = scenarioNode.getToken(TokenType.ScenarioLine);
		//     String description = getDescription(scenarioNode);
		//     List<Step> steps = getSteps(scenarioNode);
		//     return new Scenario(tags, getLocation(scenarioLine, 0), scenarioLine.matchedKeyword, scenarioLine.matchedText, description, steps);
		// } else {
		//     AstNode scenarioOutlineNode = node.getSingle(RuleType.ScenarioOutline, null);
		//     if (scenarioOutlineNode == null) {
		//         throw new RuntimeException("Internal grammar error");
		//     }
		//     Token scenarioOutlineLine = scenarioOutlineNode.getToken(TokenType.ScenarioOutlineLine);
		//     String description = getDescription(scenarioOutlineNode);
		//     List<Step> steps = getSteps(scenarioOutlineNode);
		//     List<Examples> examplesList = scenarioOutlineNode.getItems(RuleType.Examples);
		//     return new ScenarioOutline(tags, getLocation(scenarioOutlineLine, 0), scenarioOutlineLine.matchedKeyword, scenarioOutlineLine.matchedText, description, steps, examplesList);
		// }
		tags := astTags(node)
		scenarioNode, _ := node.getSingle(RuleType_Scenario).(*astNode)
		if scenarioNode != nil {
			scenarioLine := scenarioNode.getToken(TokenType_ScenarioLine)
			description, _ := scenarioNode.getSingle(RuleType_Description).(string)
			sc := new(ast.Scenario)
			sc.Type = "Scenario"
			sc.Tags = tags
			sc.Location = astLocation(scenarioLine)
			sc.Keyword = scenarioLine.Keyword
			sc.Name = scenarioLine.Text
			sc.Description = description
			sc.Steps = astSteps(scenarioNode)
			return sc, nil
		} else {
			scenarioOutlineNode, ok := node.getSingle(RuleType_ScenarioOutline).(*astNode)
			if !ok {
				panic("Internal grammar error")
			}
			scenarioOutlineLine := scenarioOutlineNode.getToken(TokenType_ScenarioOutlineLine)
			description, _ := scenarioOutlineNode.getSingle(RuleType_Description).(string)
			sc := new(ast.ScenarioOutline)
			sc.Type = "ScenarioOutline"
			sc.Tags = tags
			sc.Location = astLocation(scenarioOutlineLine)
			sc.Keyword = scenarioOutlineLine.Keyword
			sc.Name = scenarioOutlineLine.Text
			sc.Description = description
			sc.Steps = astSteps(scenarioOutlineNode)
			sc.Examples = astExamples(scenarioOutlineNode)
			return sc, nil
		}

	case RuleType_Examples:
		// List<Tag> tags = getTags(node);
		// Token examplesLine = node.getToken(TokenType.ExamplesLine);
		// String description = getDescription(node);
		// List<TableRow> allRows = getTableRows(node);
		// TableRow header = allRows.get(0);
		// List<TableRow> rows = allRows.subList(1, allRows.size());
		// return new Examples(getLocation(examplesLine, 0), tags, examplesLine.matchedKeyword, examplesLine.matchedText, description, header, rows);
		tags := astTags(node)
		examplesLine := node.getToken(TokenType_ExamplesLine)
		description, _ := node.getSingle(RuleType_Description).(string)
		allRows, err := astTableRows(node)
		ex := new(ast.Examples)
		ex.Type = "Examples"
		ex.Tags = tags
		ex.Location = astLocation(examplesLine)
		ex.Keyword = examplesLine.Keyword
		ex.Name = examplesLine.Text
		ex.Description = description
		if len(allRows) >= 1 {
			ex.Header = allRows[0]
		}
		if len(allRows) >= 2 {
			ex.Rows = allRows[1:]
		}
		return ex, err

	case RuleType_Description:
		// List<Token> lineTokens = node.getTokens(TokenType.Other);
		// // Trim trailing empty lines
		// int end = lineTokens.size();
		// while (end > 0 && lineTokens.get(end - 1).matchedText.matches("\\s*")) {
		//     end--;
		// }
		// lineTokens = lineTokens.subList(0, end);
		// return join(new StringUtils.ToString<Token>() {
		//     @Override
		//     public String toString(Token t) {
		//         return t.matchedText;
		//     }
		// }, "\n", lineTokens);

		lineTokens := node.getTokens(TokenType_Other)
		// Trim trailing empty lines
		end := len(lineTokens)
		for end > 0 && strings.TrimSpace(lineTokens[end-1].Text) == "" {
			end--
		}
		var desc []string
		for i := range lineTokens[0:end] {
			desc = append(desc, lineTokens[i].Text)
		}
		return strings.Join(desc, "\n"), nil

	case RuleType_Feature:
		// AstNode header = node.getSingle(RuleType.Feature_Header, new AstNode(RuleType.Feature_Header));
		// List<Tag> tags = getTags(header);
		// Token featureLine = header.getToken(TokenType.FeatureLine);
		// Background background = node.getSingle(RuleType.Background, null);
		// List<ScenarioDefinition> scenarioDefinitions = node.getItems(RuleType.Scenario_Definition);
		// String description = getDescription(header);
		// String language = featureLine.matchedGherkinDialect.getLanguage();
		// return new Feature(tags, getLocation(featureLine, 0), language, featureLine.matchedKeyword, featureLine.matchedText, description, background, scenarioDefinitions);
		header, ok := node.getSingle(RuleType_Feature_Header).(*astNode)
		if !ok {
			header = &astNode{ruleType: RuleType_Feature_Header}
		}
		tags := astTags(header)
		featureLine := header.getToken(TokenType_FeatureLine)
		if featureLine == nil {
			featureLine = new(Token)
			featureLine.Location = &Location{Line: 1, Column: 1}
			featureLine.Type = TokenType_FeatureLine
		}
		background, _ := node.getSingle(RuleType_Background).(*ast.Background)
		scenarioDefinitions := node.getItems(RuleType_Scenario_Definition)
		if scenarioDefinitions == nil {
			scenarioDefinitions = []interface{}{}
		}
		description, _ := header.getSingle(RuleType_Description).(string)

		feat := new(ast.Feature)
		feat.Type = "Feature"
		feat.Tags = tags
		feat.Location = astLocation(featureLine)
		feat.Language = featureLine.GherkinDialect
		feat.Keyword = featureLine.Keyword
		feat.Name = featureLine.Text
		feat.Description = description
		feat.Background = background
		feat.ScenarioDefinitions = scenarioDefinitions
		return feat, nil
	}
	return node, nil
}

func astLocation(t *Token) *ast.Location {
	return &ast.Location{
		Line:   t.Location.Line,
		Column: t.Location.Column,
	}
}

//     private List<TableRow> getTableRows(AstNode node) {
//         List<TableRow> rows = new ArrayList<>();
//         for (Token token : node.getTokens(TokenType.TableRow)) {
//             rows.add(new TableRow(getLocation(token, 0), getCells(token)));
//         }
//         ensureCellCount(rows);
//         return rows;
//     }

func astTableRows(t *astNode) (rows []*ast.TableRow, err error) {
	rows = []*ast.TableRow{}
	tokens := t.getTokens(TokenType_TableRow)
	for i := range tokens {
		row := new(ast.TableRow)
		row.Type = "TableRow"
		row.Location = astLocation(tokens[i])
		row.Cells = astTableCells(tokens[i])
		rows = append(rows, row)
	}
	err = ensureCellCount(rows)
	return
}

//     private void ensureCellCount(List<TableRow> rows) {
//         if (rows.isEmpty()) return;

//         int cellCount = rows.get(0).getCells().size();
//         for (TableRow row : rows) {
//             if (row.getCells().size() != cellCount) {
//                 throw new ParserException.AstBuilderException("inconsistent cell count within the table", row.getLocation());
//             }
//         }
//     }

func ensureCellCount(rows []*ast.TableRow) error {
	if len(rows) <= 1 {
		return nil
	}
	cellCount := len(rows[0].Cells)
	for i := range rows {
		if cellCount != len(rows[i].Cells) {
			return &parseError{"inconsistent cell count within the table", &Location{
				Line:   rows[i].Location.Line,
				Column: rows[i].Location.Column,
			}}
		}
	}
	return nil
}

//     private List<TableCell> getCells(Token token) {
//         List<TableCell> cells = new ArrayList<>();
//         for (GherkinLineSpan cellItem : token.mathcedItems) {
//             cells.add(new TableCell(getLocation(token, cellItem.Column), cellItem.Text));
//         }
//         return cells;
//     }

func astTableCells(t *Token) (cells []*ast.TableCell) {
	cells = []*ast.TableCell{}
	for i := range t.Items {
		item := t.Items[i]
		cell := new(ast.TableCell)
		cell.Type = "TableCell"
		cell.Location = &ast.Location{
			Line:   t.Location.Line,
			Column: item.Column,
		}
		cell.Value = item.Text
		cells = append(cells, cell)
	}
	return
}

func astSteps(t *astNode) (steps []*ast.Step) {
	steps = []*ast.Step{}
	tokens := t.getItems(RuleType_Step)
	for i := range tokens {
		step, _ := tokens[i].(*ast.Step)
		steps = append(steps, step)
	}
	return
}

func astExamples(t *astNode) (examples []*ast.Examples) {
	examples = []*ast.Examples{}
	tokens := t.getItems(RuleType_Examples)
	for i := range tokens {
		example, _ := tokens[i].(*ast.Examples)
		examples = append(examples, example)
	}
	return
}

//     private List<Tag> getTags(AstNode node) {
//         AstNode tagsNode = node.getSingle(RuleType.Tags, new AstNode(RuleType.None));
//         if (tagsNode == null)
//             return new ArrayList<>();

//         List<Token> tokens = tagsNode.getTokens(TokenType.TagLine);
//         List<Tag> tags = new ArrayList<>();
//         for (Token token : tokens) {
//             for (GherkinLineSpan tagItem : token.mathcedItems) {
//                 tags.add(new Tag(getLocation(token, tagItem.Column), tagItem.Text));
//             }
//         }
//         return tags;
//     }
func astTags(node *astNode) (tags []*ast.Tag) {
	tags = []*ast.Tag{}
	tagsNode, ok := node.getSingle(RuleType_Tags).(*astNode)
	if !ok {
		return
	}
	tokens := tagsNode.getTokens(TokenType_TagLine)
	for i := range tokens {
		token := tokens[i]
		for k := range token.Items {
			item := token.Items[k]
			tag := new(ast.Tag)
			tag.Type = "Tag"
			tag.Location = &ast.Location{
				Line:   token.Location.Line,
				Column: item.Column,
			}
			tag.Name = item.Text
			tags = append(tags, tag)
		}
	}
	return
}

//     private Object getTransformedNode(AstNode node) {
//         switch (node.ruleType) {
//             case Step: {
//                 Token stepLine = node.getToken(TokenType.StepLine);
//                 StepArgument stepArg = node.getSingle(RuleType.DataTable, null);
//                 if (stepArg == null) {
//                     stepArg = node.getSingle(RuleType.DocString, null);
//                 }
//                 return new Step(getLocation(stepLine, 0), stepLine.matchedKeyword, stepLine.matchedText, stepArg);
//             }
//             case DocString: {
//                 Token separatorToken = node.getTokens(TokenType.DocStringSeparator).get(0);
//                 String contentType = separatorToken.matchedText;
//                 List<Token> lineTokens = node.getTokens(TokenType.Other);
//                 StringBuilder content = new StringBuilder();
//                 boolean newLine = false;
//                 for (Token lineToken : lineTokens) {
//                     if (newLine) content.append("\n");
//                     newLine = true;
//                     content.append(lineToken.matchedText);
//                 }
//                 return new DocString(getLocation(separatorToken, 0), contentType, content.toString());
//             }
//             case DataTable: {
//                 List<TableRow> rows = getTableRows(node);
//                 return new DataTable(rows);
//             }
//             case Background: {
//                 Token backgroundLine = node.getToken(TokenType.BackgroundLine);
//                 String description = getDescription(node);
//                 List<Step> steps = getSteps(node);
//                 return new Background(getLocation(backgroundLine, 0), backgroundLine.matchedKeyword, backgroundLine.matchedText, description, steps);
//             }
//             case Scenario_Definition: {
//                 List<Tag> tags = getTags(node);
//                 AstNode scenarioNode = node.getSingle(RuleType.Scenario, null);

//                 if (scenarioNode != null) {
//                     Token scenarioLine = scenarioNode.getToken(TokenType.ScenarioLine);
//                     String description = getDescription(scenarioNode);
//                     List<Step> steps = getSteps(scenarioNode);

//                     return new Scenario(tags, getLocation(scenarioLine, 0), scenarioLine.matchedKeyword, scenarioLine.matchedText, description, steps);
//                 } else {
//                     AstNode scenarioOutlineNode = node.getSingle(RuleType.ScenarioOutline, null);
//                     if (scenarioOutlineNode == null) {
//                         throw new RuntimeException("Internal grammar error");
//                     }
//                     Token scenarioOutlineLine = scenarioOutlineNode.getToken(TokenType.ScenarioOutlineLine);
//                     String description = getDescription(scenarioOutlineNode);
//                     List<Step> steps = getSteps(scenarioOutlineNode);

//                     List<Examples> examplesList = scenarioOutlineNode.getItems(RuleType.Examples);

//                     return new ScenarioOutline(tags, getLocation(scenarioOutlineLine, 0), scenarioOutlineLine.matchedKeyword, scenarioOutlineLine.matchedText, description, steps, examplesList);

//                 }
//             }
//             case Examples: {
//                 List<Tag> tags = getTags(node);
//                 Token examplesLine = node.getToken(TokenType.ExamplesLine);
//                 String description = getDescription(node);
//                 List<TableRow> allRows = getTableRows(node);
//                 TableRow header = allRows.get(0);
//                 List<TableRow> rows = allRows.subList(1, allRows.size());
//                 return new Examples(getLocation(examplesLine, 0), tags, examplesLine.matchedKeyword, examplesLine.matchedText, description, header, rows);
//             }
//             case Description: {
//                 List<Token> lineTokens = node.getTokens(TokenType.Other);
//                 // Trim trailing empty lines
//                 int end = lineTokens.size();
//                 while (end > 0 && lineTokens.get(end - 1).matchedText.matches("\\s*")) {
//                     end--;
//                 }
//                 lineTokens = lineTokens.subList(0, end);

//                 return join(new StringUtils.ToString<Token>() {
//                     @Override
//                     public String toString(Token t) {
//                         return t.matchedText;
//                     }
//                 }, "\n", lineTokens);
//             }
//             case Feature: {
//                 AstNode header = node.getSingle(RuleType.Feature_Header, new AstNode(RuleType.Feature_Header));
//                 List<Tag> tags = getTags(header);
//                 Token featureLine = header.getToken(TokenType.FeatureLine);
//                 Background background = node.getSingle(RuleType.Background, null);
//                 List<ScenarioDefinition> scenarioDefinitions = node.getItems(RuleType.Scenario_Definition);
//                 String description = getDescription(header);
//                 String language = featureLine.matchedGherkinDialect.getLanguage();

//                 return new Feature(tags, getLocation(featureLine, 0), language, featureLine.matchedKeyword, featureLine.matchedText, description, background, scenarioDefinitions);
//             }

//         }
//         return node;
//     }

//     private void ensureCellCount(List<TableRow> rows) {
//         if (rows.isEmpty()) return;

//         int cellCount = rows.get(0).getCells().size();
//         for (TableRow row : rows) {
//             if (row.getCells().size() != cellCount) {
//                 throw new ParserException.AstBuilderException("inconsistent cell count within the table", row.getLocation());
//             }
//         }
//     }

//     private List<Step> getSteps(AstNode node) {
//         return node.getItems(RuleType.Step);
//     }

//     private Location getLocation(Token token, int column) {
//         return column == 0 ? token.location : new Location(token.location.getLine(), column);
//     }

//     private String getDescription(AstNode node) {
//         return node.getSingle(RuleType.Description, null);
//     }

//     @Override
//     public T getResult() {
//         return currentNode().getSingle(RuleType.Feature, null);
//     }
// }
