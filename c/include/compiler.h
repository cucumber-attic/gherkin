#ifndef GHERKIN_COMPILER_H_
#define GHERKIN_COMPILER_H_

#include <stdbool.h>
#include <wchar.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct Compiler Compiler;

typedef struct GherkinDocument GherkinDocument;

typedef struct Pickles Pickles;

Compiler* Compiler_new();

void Compiler_delete(Compiler* compiler);

int Compiler_compile(Compiler* compiler, const GherkinDocument* gherkin_document, const wchar_t* path);

const Pickles* Compiler_get_result(Compiler* compiler);

bool Compiler_has_more_errors(Compiler* compiler);

const wchar_t* Compiler_next_error(Compiler* compiler);

#ifdef __cplusplus
}
#endif

#endif /* GHERKIN_COMPILER_H_ */
