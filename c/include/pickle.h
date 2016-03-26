#ifndef GHERKIN_PICKLE_H_
#define GHERKIN_PICKLE_H_

#include <wchar.h>

#include "item.h"
#include "pickle_location.h"
#include "pickle_tag.h"
#include "pickle_step.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct Pickle {
    item_delete_function pickle_delete;
    const PickleLocations* locations;
    const PickleTags* tags;
    wchar_t* name;
    const PickleSteps* steps;
} Pickle;

typedef struct Pickles {
    int pickle_count;
    Pickle* pickles;
} Pickles;

const Pickle* Pickle_new(const PickleLocations* locations, const PickleTags* tags, const wchar_t* name, const PickleSteps* steps);

void Pickle_delete(const Pickle* pickle);

void Pickle_transfer(Pickle* to_pickle, Pickle* from_pickle);

void Pickles_delete(const Pickles* pickles);

#ifdef __cplusplus
}
#endif

#endif /* GHERKIN_PICKLE_H_ */
