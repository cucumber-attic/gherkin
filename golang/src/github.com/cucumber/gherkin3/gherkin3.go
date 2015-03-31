package gherkin3

import (
	"bufio"
	"fmt"
	"io"
	"strings"

	"github.com/cucumber/gherkin3/ast"
)

type Parser interface {
	StopAtFirstError(b bool)
	Parse(s Scanner, b Builder, m Matcher) (err error)
}

type Scanner interface {
	Scan() (err error, line *Line, atEof bool)
}

/*type Matcher interface{}*/

type Builder interface {
	Build(*Token) (error, bool)
	StartRule(RuleType) (error, bool)
	EndRule(RuleType) (error, bool)
}

type Location struct {
	Line   int
	Column int
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

/* func (p *parser) Parse(s Scanner, b Builder, m Matcher) (err error) {
	for {
		err, gl, eof := s.Scan()
		if err != nil || eof {
			break
		}
		// TODO...
		if gl == nil {
			break
		}
	}
	return
} */

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

func (t *scanner) Scan() (err error, line *Line, atEof bool) {
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
	lineText        string
	lineNumber      int
	trimmedLineText string
	atEof           bool
}

func (g *Line) Indent() int {
	return len(g.lineText) - len(g.trimmedLineText)
}

func (g *Line) IsEmpty() bool {
	return len(g.trimmedLineText) == 0
}

func (g *Line) IsEof() bool {
	return g.atEof
}

func (g *Line) StartsWith(prefix string) bool {
	return strings.HasPrefix(g.trimmedLineText, prefix)
}

func NewTokenGenerator(out io.Writer) Builder {
	return &tokenGenerator{out}
}

type tokenGenerator struct {
	out io.Writer
}

func FormatToken(token *Token) string {
	if token.IsEOF() {
		return "EOF"
	}
	var items []string
	for i := range token.Items {
		items = append(items, token.Items[i].String())
	}
	return fmt.Sprintf("(%d:%d)%s:%s/%s/%s",
		token.Location.Line,
		token.Location.Column,
		token.Type.Name(),
		token.Keyword,
		token.Text,
		strings.Join(items, ","),
	)
}

func (t *tokenGenerator) Build(tok *Token) (error, bool) {
	fmt.Fprintln(t.out, FormatToken(tok))
	return nil, true
}
func (t *tokenGenerator) StartRule(r RuleType) (error, bool) {
	return nil, true
}
func (t *tokenGenerator) EndRule(r RuleType) (error, bool) {
	return nil, true
}

func GenerateTokens(in io.Reader, out io.Writer) error {

	parser := NewParser()
	parser.StopAtFirstError(true)
	matcher := NewMatcher(BuildinDialects)

	scanner := NewScanner(in)
	builder := NewTokenGenerator(out)

	return parser.Parse(scanner, builder, matcher)
}

func ParseFeature(in io.Reader) (err error, feature *ast.Feature) {

	parser := NewParser()
	parser.StopAtFirstError(false)
	matcher := NewMatcher(BuildinDialects)

	scanner := NewScanner(in)
	builder := NewAstBuilder()

	err = parser.Parse(scanner, builder, matcher)

	return err, builder.getResult()
}
