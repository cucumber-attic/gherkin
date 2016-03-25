#include "background.h"
#include <stdlib.h>

const Background* Background_new(Location location, const wchar_t* keyword, const wchar_t* name, const Steps* steps) {
    Background* background = (Background*)malloc(sizeof(Background));
    background->background_delete = (item_delete_function)Background_delete;
    background->type = Gherkin_Background;
    background->location.line = location.line;
    background->location.column = location.column;
    background->keyword = 0;
    if (keyword) {
        int length = wcslen(keyword);
        background->keyword = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(background->keyword, keyword, length);
        background->keyword[length] = L'\0';
    }
    background->name = 0;
    if (name) {
        int length = wcslen(name);
        background->name = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(background->name, name, length);
        background->name[length] = L'\0';
    }
    background->steps = steps;
    return background;
}

void Background_delete(const Background* background) {
    if (!background) {
        return;
    }
    if (background->keyword) {
        free((void*)background->keyword);
    }
    if (background->name) {
        free((void*)background->name);
    }
    if (background->steps) {
        Steps_delete(background->steps);
    }
    free((void*)background);
}

void Background_transfer(Background* to_background, Background* from_background) {
    to_background->type = from_background->type;
    to_background->location.line = from_background->location.line;
    to_background->location.column = from_background->location.column;
    to_background->keyword = from_background->keyword;
    from_background->keyword = 0;
    to_background->name = from_background->name;
    from_background->name = 0;
    to_background->steps = from_background->steps;
    from_background->steps = 0;
    Background_delete(from_background);
}
