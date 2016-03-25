#include "doc_string.h"
#include <stdlib.h>

const DocString* DocString_new(Location location, const wchar_t* content_type, const wchar_t* content) {
    DocString* doc_string = (DocString*)malloc(sizeof(DocString));
    doc_string->doc_string_delete = (item_delete_function)DocString_delete;
    doc_string->type = Gherkin_DocString;
    doc_string->location.line = location.line;
    doc_string->location.column = location.column;
    doc_string->content_type = 0;
    if (content_type && wcslen(content_type) > 0) {
        int length = wcslen(content_type);
        doc_string->content_type = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(doc_string->content_type, content_type, length);
        doc_string->content_type[length] = L'\0';
    }
    doc_string->content = content;
    return doc_string;
}

void DocString_delete(const DocString* doc_string) {
    if (!doc_string) {
        return;
    }
    if (doc_string->content_type) {
        free((void*)doc_string->content_type);
    }
    if (doc_string->content) {
        free((void*)doc_string->content);
    }
    free((void*)doc_string);
}
