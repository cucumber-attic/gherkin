package gherkin

import (
	"bufio"
	"fmt"
	"io"
	"strings"
)

type Parser interface {
	StopAtFirstError(b bool)
	Parse(s Scanner, b Builder, m Matcher) (err error)
}

type Scanner interface {
	Scan() (line *Line, atEof bool, err error)
}

type Builder interface {
	Build(*Token) (bool, error)
	StartRule(RuleType) (bool, error)
	EndRule(RuleType) (bool, error)
        Reset()
}

type Token struct {
	Type           TokenType
	Keyword        string
	Text           string
	Items          []*LineSpan
	GherkinDialect string
	Indent         string
	Location       *Location
}

func (t *Token) IsEOF() bool {
	return t.Type == TokenType_EOF
}
func (t *Token) String() string {
	return fmt.Sprintf("%s: %s/%s", t.Type, t.Keyword, t.Text)
}

type LineSpan struct {
	Column int
	Text   string
}

func (l *LineSpan) String() string {
	return fmt.Sprintf("%d:%s", l.Column, l.Text)
}

type parser struct {
	stopAtFirstError bool
}

func NewParser() Parser {
	return &parser{}
}

func (p *parser) StopAtFirstError(b bool) {
	p.stopAtFirstError = b
}

func NewScanner(r io.Reader) Scanner {
	return &scanner{
		s:    bufio.NewScanner(r),
		line: 0,
	}
}

type scanner struct {
	s    *bufio.Scanner
	line int
}

func (t *scanner) Scan() (line *Line, atEof bool, err error) {
	scanning := t.s.Scan()
	if !scanning {
		err = t.s.Err()
		if err == nil {
			atEof = true
		}
	}
	if err == nil {
		t.line += 1
		str := t.s.Text()
		line = &Line{str, t.line, strings.TrimLeft(str, " \t"), atEof}
	}
	return
}

type Line struct {
	LineText        string
	LineNumber      int
	TrimmedLineText string
	AtEof           bool
}

func (g *Line) Indent() int {
	return len(g.LineText) - len(g.TrimmedLineText)
}

func (g *Line) IsEmpty() bool {
	return len(g.TrimmedLineText) == 0
}

func (g *Line) IsEof() bool {
	return g.AtEof
}

func (g *Line) StartsWith(prefix string) bool {
	return strings.HasPrefix(g.TrimmedLineText, prefix)
}

func ParseFeature(in io.Reader) (feature *Feature, err error) {

	parser := NewParser()
	parser.StopAtFirstError(false)
	matcher := NewMatcher(GherkinDialectsBuildin())

	scanner := NewScanner(in)
	builder := NewAstBuilder()

	err = parser.Parse(scanner, builder, matcher)

	return builder.GetFeature(), err
}
