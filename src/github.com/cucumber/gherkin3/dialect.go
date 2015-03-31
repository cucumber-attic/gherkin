package gherkin3

type GherkinDialect struct {
	language string
	name     string
	native   string
	keywords map[string][]string
}

func (g *GherkinDialect) FeatureKeywords() []string {
	return g.keywords["feature"]
}

func (g *GherkinDialect) ScenarioKeywords() []string {
	return g.keywords["scenario"]
}

func (g *GherkinDialect) StepKeywords() []string {
	result := g.keywords["given"]
	result = append(result, g.keywords["when"]...)
	result = append(result, g.keywords["then"]...)
	result = append(result, g.keywords["and"]...)
	result = append(result, g.keywords["but"]...)
	return result
}

func (g *GherkinDialect) BackgroundKeywords() []string {
	return g.keywords["background"]
}

func (g *GherkinDialect) ScenarioOutlineKeywords() []string {
	return g.keywords["scenarioOutline"]
}

func (g *GherkinDialect) ExamplesKeywords() []string {
	return g.keywords["examples"]
}

func (g *GherkinDialect) Language() string {
	return g.language
}

func (g *GherkinDialect) Name() string {
	return g.name
}

func (g *GherkinDialect) Native() string {
	return g.native
}

type GherkinDialectProvider interface {
	GetDialect(language string) *GherkinDialect
}

type GherkinDialectMap map[string]*GherkinDialect

func (g GherkinDialectMap) GetDialect(language string) *GherkinDialect {
	return g[language]
}
