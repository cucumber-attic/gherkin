#include "pickle_tag.h"
#include <stdlib.h>

static void delete_tag_content(const PickleTag* tag);

const PickleTag* PickleTag_new(const wchar_t* name, int line, int column) {
    PickleTag* tag = (PickleTag*)malloc(sizeof(PickleTag));
    tag->location.line = line;
    tag->location.column = column;
    tag->location.path = 0;
    tag->name = 0;
    if (name) {
        int length = wcslen(name);
        tag->name = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(tag->name, name, length);
        tag->name[length] = L'\0';
    }
    return tag;
}

void PickleTag_delete(const PickleTag* tag) {
    if (!tag) {
        return;
    }
    delete_tag_content(tag);
    free((void*)tag);
}

void PickleTag_transfer(PickleTag* to_tag, const wchar_t* name, int line, int column, const wchar_t* path) {
    to_tag->location.line = line;
    to_tag->location.column = column;
    to_tag->location.path = 0;
    if (path) {
        int length = wcslen(path);
        to_tag->location.path = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(to_tag->location.path, path, length);
        to_tag->location.path[length] = L'\0';
    }
    to_tag->name = 0;
    if (name) {
        int length = wcslen(name);
        to_tag->name = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(to_tag->name, name, length);
        to_tag->name[length] = L'\0';
    }
}

void PickleTags_delete(const PickleTags* tags) {
    if (!tags) {
        return;
    }
    int i;
    for(i = 0; i < tags->tag_count; ++i) {
        delete_tag_content(tags->tags + i);
    }
    free((void*)tags);
}

static void delete_tag_content(const PickleTag* tag) {
    if (tag->name) {
        free((void*)tag->name);
    }
}
