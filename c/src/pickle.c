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

void Pickle_transfer(Pickle* to_pickle, Pickle* from_pickle) {
    to_pickle->locations = from_pickle->locations;
    from_pickle->locations = 0;
    to_pickle->tags = from_pickle->tags;
    from_pickle->tags = 0;
    to_pickle->name = from_pickle->name;
    from_pickle->name = 0;
    to_pickle->steps = from_pickle->steps;
    from_pickle->steps = 0;
    Pickle_delete(from_pickle);
}

void Pickles_delete(const Pickles* pickles) {
    if (!pickles) {
        return;
    }
    int i;
    for (i = 0; i < pickles->pickle_count; ++i) {
        delete_pickle_content(pickles->pickles + i);
    }
    free((void*)pickles);
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
