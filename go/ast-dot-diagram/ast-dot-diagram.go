package main

import (
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"io/ioutil"
	"os"
	"strings"
)

func main() {

	file, _ := os.OpenFile("ast.go", os.O_RDONLY, 0)
	bytes, _ := ioutil.ReadAll(file)

	fset := token.NewFileSet() // positions are relative to fset
	f, _ := parser.ParseFile(fset, "ast.go", string(bytes), 0)

	fmt.Fprintf(os.Stdout, "digraph {\n")

	fmt.Fprintf(os.Stdout, "  ranksep=3\n")
	fmt.Fprintf(os.Stdout, "  node [shape=record]\n")

	var edges []string

	for i := range f.Decls {
		dec := f.Decls[i]
		if dec, ok := dec.(*ast.GenDecl); ok {
			if dec.Tok == token.TYPE {
				for s := range dec.Specs {
					if s, ok := dec.Specs[s].(*ast.TypeSpec); ok {
						if ss, ok := s.Type.(*ast.StructType); ok {
							name := s.Name.Name
							fields := []string{}
							for f := range ss.Fields.List {
								field := ss.Fields.List[f]
								if field.Names == nil {
									if t, ok := field.Type.(*ast.Ident); ok {
										edges = append(edges, fmt.Sprintf("  \"%s\" -> \"%s\" [arrowhead=empty] \n", name, t.Name))
									}
								} else if len(field.Names) == 1 {
									fieldName := field.Names[0].Name
									fieldType := "unknown"
									switch ty := field.Type.(type) {
									case *ast.Ident:
										fieldType = ty.Name

									case *ast.StarExpr:
										if ty, ok := ty.X.(*ast.Ident); ok {
											fieldType = ty.Name
											edges = append(edges, fmt.Sprintf("  \"%s\":%s -> \"%s\" [arrowhead=diamond;taillabel=\"1\"] \n", name, fieldName, ty.Name))
										}

									case *ast.ArrayType:
										switch tyelt := ty.Elt.(type) {
										case *ast.Ident:
											fieldType = tyelt.Name + "[]"

										case *ast.StarExpr:
											if tyelt, ok := tyelt.X.(*ast.Ident); ok {
												fieldType = tyelt.Name + "[]"
												edges = append(edges, fmt.Sprintf("  \"%s\":%s -> \"%s\" [arrowhead=diamond;taillabel=\"0..*\"] \n", name, fieldName, tyelt.Name))
											}

										default:
											fieldType = "unknown[]"
										}
									}
									fields = append(fields, fmt.Sprintf("{<%s>%s: %s}", fieldName, fieldName, fieldType))

								}
							}
							fmt.Fprintf(os.Stdout, "  \"%s\" [label=\"%s|{|{%s}}\"]\n", name, name, strings.Join(fields, "|"))
						}
					}
				}
			}
		}
	}

	for i := range edges {
		fmt.Fprintf(os.Stdout, edges[i])
	}

	fmt.Fprintf(os.Stdout, "}\n")
}
