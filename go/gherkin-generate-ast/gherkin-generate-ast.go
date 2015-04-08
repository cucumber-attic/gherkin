package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"

	gherkin "../"
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
		err := GenerateAst(readers[i], os.Stdout, false)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s\n", err)
			os.Exit(1)
			return
		}
	}
}

func GenerateAst(in io.Reader, out io.Writer, pretty bool) (err error) {
	feature, err := gherkin.ParseFeature(in)
	if err != nil {
		return
	}
	var bytes []byte
	if pretty {
		bytes, err = json.MarshalIndent(feature, "", "  ")
	} else {
		bytes, err = json.Marshal(feature)
	}
	if err != nil {
		return
	}
	out.Write(bytes)
	fmt.Fprint(out, "\n")
	return
}
