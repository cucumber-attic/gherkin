package gherkin_test

import (
	"fmt"
	"os"
	"strings"

	gherkin "."
)

func ExampleParseFeature() {

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

	feature, err := gherkin.ParseFeature(r)
	if err != nil {
		fmt.Fprintf(os.Stdout, "%s\n", err)
		return
	}
	fmt.Fprintf(os.Stdout, "Location: %+v\n", feature.Location)
	fmt.Fprintf(os.Stdout, "Keyword: %+v\n", feature.Keyword)
	fmt.Fprintf(os.Stdout, "Name: %+v\n", feature.Name)
	fmt.Fprintf(os.Stdout, "ScenarioDefinitions: length: %+v\n", len(feature.ScenarioDefinitions))

	scenario1, _ := feature.ScenarioDefinitions[0].(*gherkin.ScenarioOutline)
	fmt.Fprintf(os.Stdout, " 1: Location: %+v\n", scenario1.Location)
	fmt.Fprintf(os.Stdout, "    Keyword: %+v\n", scenario1.Keyword)
	fmt.Fprintf(os.Stdout, "    Name: %+v\n", scenario1.Name)
	fmt.Fprintf(os.Stdout, "    Steps: length: %+v\n", len(scenario1.Steps))

	scenario2, _ := feature.ScenarioDefinitions[1].(*gherkin.Scenario)
	fmt.Fprintf(os.Stdout, " 2: Location: %+v\n", scenario2.Location)
	fmt.Fprintf(os.Stdout, "    Keyword: %+v\n", scenario2.Keyword)
	fmt.Fprintf(os.Stdout, "    Name: %+v\n", scenario2.Name)
	fmt.Fprintf(os.Stdout, "    Steps: length: %+v\n", len(scenario2.Steps))

	// Output:
	//
	// Location: &{Line:1 Column:1}
	// Keyword: Feature
	// Name: Tagged Examples
	// ScenarioDefinitions: length: 2
	//  1: Location: &{Line:3 Column:3}
	//     Keyword: Scenario Outline
	//     Name: minimalistic
	//     Steps: length: 1
	//  2: Location: &{Line:17 Column:3}
	//     Keyword: Scenario
	//     Name: ha ok
	//     Steps: length: 0
	//
}
