package gherkin_test

import (
	"os"
	"strings"

	"github.com/cucumber/gherkin3"
)

func ExampleGenerateTokens() {

	input := `Feature: Minimal

  Scenario: minimalistic
    Given the minimalism`
	r := strings.NewReader(input)

	gherkin3.GenerateTokens(r, os.Stdout)

	// Output:
	// (1:1)FeatureLine:Feature/Minimal/
	// (2:1)Empty://
	// (3:3)ScenarioLine:Scenario/minimalistic/
	// (4:5)StepLine:Given /the minimalism/
	// EOF
}

func ExampleGenerateTokens2() {

	input := `Feature: Tagged Examples

  Scenario Outline: minimalistic
    Given the <what>

    @foo
    Examples:
      | what |
      | foo  |

    @bar
    Examples:
      | what |
      | bar  |

  @zap
  Scenario: ha ok
`
	r := strings.NewReader(input)

	gherkin3.GenerateTokens(r, os.Stdout)

	// Output:
	// (1:1)FeatureLine:Feature/Tagged Examples/
	// (2:1)Empty://
	// (3:3)ScenarioOutlineLine:Scenario Outline/minimalistic/
	// (4:5)StepLine:Given /the <what>/
	// (5:1)Empty://
	// (6:5)TagLine://5:@foo
	// (7:5)ExamplesLine:Examples//
	// (8:7)TableRow://9:what
	// (9:7)TableRow://9:foo
	// (10:1)Empty://
	// (11:5)TagLine://5:@bar
	// (12:5)ExamplesLine:Examples//
	// (13:7)TableRow://9:what
	// (14:7)TableRow://9:bar
	// (15:1)Empty://
	// (16:3)TagLine://3:@zap
	// (17:3)ScenarioLine:Scenario/ha ok/
	// EOF
	//
}
