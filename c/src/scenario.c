#include "scenario.h"
#include <stdlib.h>

const Scenario* Scenario_new(Location location, const wchar_t* keyword, const wchar_t* name, const wchar_t* description, const Tags* tags, const Steps* steps) {
    Scenario* scenario = (Scenario*)malloc(sizeof(Scenario));
    scenario->scenario_delete = (item_delete_function)Scenario_delete;
    scenario->type = Gherkin_Scenario;
    scenario->location.line = location.line;
    scenario->location.column = location.column;
    scenario->keyword = 0;
    if (keyword) {
        int length = wcslen(keyword);
        scenario->keyword = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(scenario->keyword, keyword, length);
        scenario->keyword[length] = L'\0';
    }
    scenario->name = 0;
    if (name) {
        int length = wcslen(name);
        scenario->name = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(scenario->name, name, length);
        scenario->name[length] = L'\0';
    }
    scenario->description = description;
    scenario->tags = tags;
    scenario->steps = steps;
    return scenario;
}

void Scenario_delete(const Scenario* scenario) {
    if (!scenario) {
        return;
    }
    if (scenario->keyword) {
        free((void*)scenario->keyword);
    }
    if (scenario->name) {
        free((void*)scenario->name);
    }
    if (scenario->description) {
        free((void*)scenario->description);
    }
    if (scenario->tags) {
        Tags_delete(scenario->tags);
    }
    if (scenario->steps) {
        Steps_delete(scenario->steps);
    }
    free((void*)scenario);
}

void Scenario_transfer(Scenario* to_scenario, Scenario* from_scenario) {
    to_scenario->type = from_scenario->type;
    to_scenario->location.line = from_scenario->location.line;
    to_scenario->location.column = from_scenario->location.column;
    to_scenario->keyword = from_scenario->keyword;
    from_scenario->keyword = 0;
    to_scenario->name = from_scenario->name;
    from_scenario->name = 0;
    to_scenario->description = from_scenario->description;
    from_scenario->description = 0;
    to_scenario->tags = from_scenario->tags;
    from_scenario->tags = 0;
    to_scenario->steps = from_scenario->steps;
    from_scenario->steps = 0;
    Scenario_delete(from_scenario);
}
