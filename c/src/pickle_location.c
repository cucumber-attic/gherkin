#include "pickle_location.h"
#include <stdlib.h>

static wchar_t* copy_path(const wchar_t* path);

static void delete_pickle_location_content(const PickleLocation* location);

const PickleLocation* PickleLocation_new(int line, int column, const wchar_t* path) {
    PickleLocation* location = (PickleLocation*)malloc(sizeof(PickleLocation));
    location->line = line;
    location->column = column;
    location->path = 0;
    if (path) {
        location->path = copy_path(path);
    }
    return location;
}

const PickleLocations* PickleLocations_new_single(int line, int column, const wchar_t* path) {
    const PickleLocation* location = PickleLocation_new(line, column, path);
    PickleLocations* locations = (PickleLocations*)malloc(sizeof(PickleLocations));
    locations->location_count = 1;
    locations->locations = location;
    return locations;
}

const PickleLocations* PickleLocations_new_double(int line_1, int column_1, int line_2, int column_2, const wchar_t* path) {
    PickleLocation* location_array = (PickleLocation*)malloc(2 * sizeof(PickleLocation));
    location_array[0].line = line_1;
    location_array[0].column = column_1;
    location_array[0].path = 0;
    location_array[1].line = line_2;
    location_array[1].column = column_2;
    location_array[1].path = 0;
    if (path) {
        location_array[0].path = copy_path(path);
        location_array[1].path = copy_path(path);
    }
    PickleLocations* locations = (PickleLocations*)malloc(sizeof(PickleLocations));
    locations->location_count = 2;
    locations->locations = location_array;
    return locations;
}

void PickleLocation_delete(const PickleLocation* location) {
    if (!location) {
        return;
    }
    delete_pickle_location_content(location);
    free((void*) location);
}

void PickleLocations_delete(const PickleLocations* locations) {
    if (!locations) {
        return;
    }
    if (locations->locations) {
        int i;
        for (i = 0; i < locations->location_count; ++i) {
            delete_pickle_location_content(&locations->locations[i]);
        }
        free((void*) locations->locations);
    }
    free((void*) locations);
}

static void delete_pickle_location_content(const PickleLocation* location) {
    if (location->path) {
        free((void*) location->path);
    }
}

static wchar_t* copy_path(const wchar_t* path) {
    int length = wcslen(path);
    wchar_t* new_path = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
    wmemcpy(new_path, path, length);
    new_path[length] = L'\0';
    return new_path;
}
