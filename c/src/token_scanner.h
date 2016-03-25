#ifndef GHERKIN_TOKEN_SCANNER_H_
#define GHERKIN_TOKEN_SCANNER_H_

#include "token.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct TokenScanner TokenScanner;

typedef Token* (*read_function) (TokenScanner*);

typedef struct TokenScanner {
    read_function read;
} TokenScanner;

TokenScanner* TokenScanner_new(const char* const file_name);

void TokenScanner_delete(TokenScanner* token_scanner);

#ifdef __cplusplus
}
#endif

#endif /* GHERKIN_TOKEN_SCANNER_H_ */
