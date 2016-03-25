#ifndef GHERKIN_AST_PRINTER_H_
#define GHERKIN_AST_PRINTER_H_

#include "feature.h"
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

void AstPrinter_print_feature(FILE* file, const Feature* feature);

#ifdef __cplusplus
}
#endif

#endif /* GHERKIN_AST_PRINTER_H_ */
