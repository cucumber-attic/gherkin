#include "error.h"
#include <stdlib.h>

Error* Error_new(const wchar_t* error_text) {
    Error* error = (Error*)malloc(sizeof(Error));
    error->error_delete = (item_delete_function)Error_delete;
    error->error_text = error_text;
    return error;
}

void Error_delete(Error* error) {
    if (error->error_text) {
        free((void*)error->error_text);
    }
    free((void*)error);
}
