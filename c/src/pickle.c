#include "pickle.h"
#include <stdlib.h>

static void delete_pickle_content(const Pickle* pickle);

const Pickle* Pickle_new(const PickleLocations* locations, const PickleTags* tags, const wchar_t* name, const PickleSteps* steps) {
    Pickle* pickle = (Pickle*)malloc(sizeof(Pickle));
    pickle->pickle_delete = (item_delete_function)Pickle_delete;
    pickle->locations = locations;
    pickle->tags = tags;
    pickle->name = 0;
    if (name) {
        int name_length = wcslen(name);
        pickle->name = (wchar_t*)malloc((name_length + 1) * sizeof(wchar_t));
        wmemcpy(pickle->name, name, name_length);
        pickle->name[name_length] = L'\0';
    }
    pickle->steps = steps;
    return pickle;
}

void Pickle_delete(const Pickle* pickle) {
    if (!pickle) {
        return;
    }
    delete_pickle_content(pickle);
    free((void*)pickle);
}

static void delete_pickle_content(const Pickle* pickle) {
    if (pickle->locations) {
        PickleLocations_delete(pickle->locations);
    }
    if (pickle->tags) {
        PickleTags_delete(pickle->tags);
    }
    if (pickle->name) {
        free((void*)pickle->name);
    }
    if (pickle->steps) {
        PickleSteps_delete(pickle->steps);
    }
}
