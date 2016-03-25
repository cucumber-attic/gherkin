#include "feature.h"
#include "scenario.h"
#include "scenario_outline.h"
#include <stdlib.h>

const Feature* Feature_new(Location location, const wchar_t* language, const wchar_t* keyword, const wchar_t* name, const wchar_t* description, const Tags* tags, const ScenarioDefinitions* scenario_definitions, const Comments* comments) {
    Feature* feature = (Feature*)malloc(sizeof(Feature));
    feature->feature_delete = (item_delete_function)Feature_delete;
    feature->type = Gherkin_Feature;
    feature->location.line = location.line;
    feature->location.column = location.column;
    feature->language = 0;
    if (language) {
        int length = wcslen(language);
        feature->language = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(feature->language, language, length);
        feature->language[length] = L'\0';
    }
    if (keyword) {
        int length = wcslen(keyword);
        feature->keyword = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(feature->keyword, keyword, length);
        feature->keyword[length] = L'\0';
    }
    if (name) {
        int length = wcslen(name);
        feature->name = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(feature->name, name, length);
        feature->name[length] = L'\0';
    }
    feature->description = description;
    feature->tags = tags;
    feature->scenario_definitions = scenario_definitions;
    feature->comments = comments;
    return feature;
}

void Feature_delete(const Feature* feature) {
    if (!feature) {
        return;
    }
    if (feature->language) {
        free((void*)feature->language);
    }
    if (feature->keyword) {
        free((void*)feature->keyword);
    }
    if (feature->name) {
        free((void*)feature->name);
    }
    if (feature->description) {
        free((void*)feature->description);
    }
    if (feature->tags) {
        Tags_delete(feature->tags);
    }
    if (feature->scenario_definitions) {
        ScenarioDefinition* scenario_definition;
        int i;
        for(i = 0; i < feature->scenario_definitions->scenario_definition_count; ++i) {
            scenario_definition = feature->scenario_definitions->scenario_definitions[i];
            if (scenario_definition->type == Gherkin_Background) {
                Background_delete((Background*)scenario_definition);
            }
            else if (scenario_definition->type == Gherkin_Scenario) {
                Scenario_delete((Scenario*)scenario_definition);
            }
            else if (scenario_definition->type == Gherkin_ScenarioOutline) {
                ScenarioOutline_delete((ScenarioOutline*)scenario_definition);
            }
        }
        free((void*)feature->scenario_definitions);
    }
    if (feature->comments) {
        Comments_delete(feature->comments);
    }
    free((void*)feature);
}
