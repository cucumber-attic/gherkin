#include "pickle_string.h"
#include <stdlib.h>

const PickleString* PickleString_new(const wchar_t* content, int line, int column, const wchar_t* path) {
    PickleString* pickle_string = (PickleString*)malloc(sizeof(PickleString));
    pickle_string->type = Argument_String;
    pickle_string->location.line = line;
    pickle_string->location.column = column;
    pickle_string->location.path = 0;
    if (path) {
        int length = wcslen(path);
        pickle_string->location.path = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(pickle_string->location.path, path, length);
        pickle_string->location.path[length] = L'\0';
    }
    pickle_string->content = 0;
    if (content) {
        int length = wcslen(content);
        pickle_string->content = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(pickle_string->content, content, length);
        pickle_string->content[length] = L'\0';
    }
    return pickle_string;
}

void PickleString_delete(const PickleString* pickle_string) {
    if (!pickle_string) {
        return;
    }
    if (pickle_string->content) {
        free((void*)pickle_string->content);
    }
    free((void*)pickle_string);
}
