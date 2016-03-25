#ifndef GHERKIN_ERROR_H_
#define GHERKIN_ERROR_H_

#include "item.h"
#include <wchar.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct Error {
    item_delete_function error_delete;
    const wchar_t* error_text;
} Error;

Error* Error_new(const wchar_t* error_text);

void Error_delete(Error* error);

#ifdef __cplusplus
}
#endif

#endif /* GHERKIN_ERROR_H_ */
