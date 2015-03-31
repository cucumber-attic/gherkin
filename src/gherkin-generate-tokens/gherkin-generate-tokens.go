package main

import (
	"fmt"
	"io"
	"os"

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
		err := gherkin3.GenerateTokens(readers[i], os.Stdout)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %s\n", err)
			os.Exit(1)
			return
		}
	}
}
