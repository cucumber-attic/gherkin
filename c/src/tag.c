#include "tag.h"
#include <stdlib.h>

static void delete_tag_content(const Tag* tag);

const Tag* Tag_new(Location location, const wchar_t* name) {
    Tag* tag = (Tag*)malloc(sizeof(Tag));
    tag->tag_delete = (item_delete_function)Tag_delete;
    tag->type = Gherkin_Tag;
    tag->location.line = location.line;
    tag->location.column = location.column;
    if (name) {
        int length = wcslen(name);
        tag->name = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(tag->name, name, length);
        tag->name[length] = L'\0';
    }
    return tag;
}

void Tag_delete(const Tag* tag) {
    if (!tag) {
        return;
    }
    delete_tag_content(tag);
    free((void*)tag);
}

void Tag_transfer(Tag* to_tag, Location location, const wchar_t* name) {
    to_tag->type = Gherkin_Tag;
    to_tag->location.line = location.line;
    to_tag->location.column = location.column;
    if (name) {
        int length = wcslen(name);
        to_tag->name = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(to_tag->name, name, length);
        to_tag->name[length] = L'\0';
    }
}

void Tags_delete(const Tags* tags) {
    if (!tags) {
        return;
    }
    int i;
    for(i = 0; i < tags->tag_count; ++i) {
        delete_tag_content(tags->tags + i);
    }
    free((void*)tags);
}

static void delete_tag_content(const Tag* tag) {
    if (tag->name) {
        free((void*)tag->name);
    }
}
