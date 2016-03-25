#ifndef GHERKIN_PICKLE_PRINTER_H_
#define GHERKIN_PICKLE_PRINTER_H_

#include "pickle.h"
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

void PicklePrinter_print_pickles(FILE* file, const Pickles* pickles);

#ifdef __cplusplus
}
#endif

#endif /* GHERKIN_PICKLE_PRINTER_H_ */
