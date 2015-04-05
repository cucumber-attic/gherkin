package main

import (
	"fmt"
	"io"
	"os"
	"strings"

	"github.com/cucumber/gherkin3"
)

func main() {

	var readers []io.Reader
	if len(os.Args) <= 1 {
		readers = append(readers, os.Stdin)
	} else {
		for i := range os.Args[1:] {
			file, err := os.Open(os.Args[i+1])
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error: %s\n", err)
				os.Exit(1)
				return
			}
			readers = append(readers, file)
		}
	}

	for i := range readers {
		err := GenerateTokens(readers[i], os.Stdout)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %s\n", err)
			os.Exit(1)
			return
		}
	}
}

type tokenGenerator struct {
	out io.Writer
}

func FormatToken(token *gherkin3.Token) string {
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

func (t *tokenGenerator) Build(tok *gherkin3.Token) (bool, error) {
	fmt.Fprintln(t.out, FormatToken(tok))
	return true, nil
}
func (t *tokenGenerator) StartRule(r gherkin3.RuleType) (bool, error) {
	return true, nil
}
func (t *tokenGenerator) EndRule(r gherkin3.RuleType) (bool, error) {
	return true, nil
}

func GenerateTokens(in io.Reader, out io.Writer) error {

	parser := gherkin3.NewParser()
	parser.StopAtFirstError(true)
	matcher := gherkin3.NewMatcher(gherkin3.GherkinDialectsBuildin())

	scanner := gherkin3.NewScanner(in)
	builder := &tokenGenerator{out}

	return parser.Parse(scanner, builder, matcher)
}
