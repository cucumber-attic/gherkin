package gherkin3

type Location struct {
	Line   int `json:"line"`
	Column int `json:"column"`
}

type Node struct {
	Location *Location `json:"location,omitempty"`
	Type     string    `json:"type"`
}

type Feature struct {
	Node
	Tags                []*Tag        `json:"tags"`
	Language            string        `json:"language,omitempty"`
	Keyword             string        `json:"keyword"`
	Name                string        `json:"name"`
	Description         string        `json:"description,omitempty"`
	Background          *Background   `json:"background,omitempty"`
	ScenarioDefinitions []interface{} `json:"scenarioDefinitions"`
}

func (f *Feature) DescribeTo(v Visitor) {
	v.VisitFeature(f)
}

type Tag struct {
	Node
	Location *Location `json:"location,omitempty"`
	Name     string    `json:"name"`
}

type Background struct {
	ScenarioDefinition
}

func (b *Background) DescribeTo(v Visitor) {
	v.VisitBackground(b)
}

type Scenario struct {
	ScenarioDefinition
	Tags []*Tag `json:"tags"`
}

func (s *Scenario) DescribeTo(v Visitor) {
	v.VisitScenario(s)
}

type ScenarioOutline struct {
	ScenarioDefinition
	Tags     []*Tag      `json:"tags"`
	Examples []*Examples `json:"examples,omitempty"`
}

func (s *ScenarioOutline) DescribeTo(v Visitor) {
	v.VisitScenarioOutline(s)
}

type Examples struct {
	Node
	Tags        []*Tag      `json:"tags"`
	Keyword     string      `json:"keyword"`
	Name        string      `json:"name"`
	Description string      `json:"description,omitempty"`
	Header      *TableRow   `json:"header"`
	Rows        []*TableRow `json:"rows"`
}

func (e *Examples) DescribeTo(v Visitor) {
	v.VisitExamples(e)
}

type TableRow struct {
	Node
	Cells []*TableCell `json:"cells"`
}

type TableCell struct {
	Node
	Value string `json:"value"`
}

type ScenarioDefinition struct {
	Node
	Keyword     string  `json:"keyword"`
	Name        string  `json:"name"`
	Description string  `json:"description,omitempty"`
	Steps       []*Step `json:"steps"`
}

type Step struct {
	Node
	Keyword  string      `json:"keyword"`
	Name     string      `json:"name"`
	Argument interface{} `json:"argument,omitempty"`
}

func (s *Step) DescribeTo(v Visitor) {
	v.VisitStep(s)
}

type DocString struct {
	Node
	ContentType string `json:"contentType"`
	Content     string `json:"content"`
	Delimitter  string `json:"-"`
}

type DataTable struct {
	Node
	Rows []*TableRow `json:"rows"`
}

type HasTags interface {
	Tags() []*Tag
}

type HasSteps interface {
	Steps() []*Step
}

type DescribesItself interface {
	DescribeTo(Visitor)
}

type Visitor interface {
	VisitFeature(*Feature)
	VisitBackground(*Background)
	VisitScenario(*Scenario)
	VisitScenarioOutline(*ScenarioOutline)
	VisitExamples(*Examples)
	VisitStep(*Step)
}
