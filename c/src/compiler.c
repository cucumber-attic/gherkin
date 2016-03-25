#include "compiler.h"
#include "pickle.h"
#include "item_queue.h"
#include "feature.h"
#include "scenario.h"
#include "scenario_outline.h"
#include "data_table.h"
#include "doc_string.h"
#include "pickle_table.h"
#include "pickle_tag.h"
#include "pickle_string.h"
#include <stdlib.h>

typedef struct Compiler {
    ItemQueue* pickle_list;
} Compiler;

typedef struct ReplacementItem {
    item_delete_function item_delete;
    int start_position;
    int old_length;
    const wchar_t* new_text;
} ReplacementItem;

static const PickleArgument* create_pickle_argument(const StepArgument* step_argument, const TableRow* example_header, const TableRow* body_row, const wchar_t* path);

static const PickleTable* create_pickle_table(DataTable* data_table, const TableRow* example_header, const TableRow* body_row, const wchar_t* path);

static const PickleTags* create_pickle_tags(const Tags* source_1, const Tags* source_2, const Tags* source_3, const wchar_t* path);

static void copy_tags(PickleTag* destination_array, const Tags* source, const wchar_t* path);

static void copy_steps(PickleStep* destination_array, const Steps* source, const wchar_t* path);

static const PickleStep* expand_outline_step(const Step* outline_step, const TableRow* example_header, const TableRow* body_row, const PickleLocations* locations);

static const wchar_t* create_expanded_text(const wchar_t* original_text, const TableRow* example_header, const TableRow* body_row);

static void ReplacementItem_delete(ReplacementItem* item);

Compiler* Compiler_new() {
    Compiler* compiler = (Compiler*)malloc(sizeof(Compiler));
    compiler->pickle_list = ItemQueue_new();
    return compiler;
}

void Compiler_delete(Compiler* compiler) {
    ItemQueue_delete(compiler->pickle_list);
    free((void*)compiler);
}

int Compiler_compile(Compiler* compiler, const Feature* feature, const wchar_t* path) {
    if (!feature) {
        return 0;
    }
    int background_step_count = 0;
    const Steps* background_steps = 0;
    int i;
    for (i = 0; i < feature->scenario_definitions->scenario_definition_count; ++i) {
        if (feature->scenario_definitions->scenario_definitions[i]->type == Gherkin_Background) {
            const Background* background = (const Background*)feature->scenario_definitions->scenario_definitions[i];
            background_step_count = background->steps->step_count;
            background_steps = background->steps;
        }
        else if (feature->scenario_definitions->scenario_definitions[i]->type == Gherkin_Scenario) {
            const Scenario* scenario = (const Scenario*)feature->scenario_definitions->scenario_definitions[i];
            if (scenario->steps->step_count == 0) {
                continue;
            }
            const PickleLocations* locations = PickleLocations_new_single(scenario->location.line, scenario->location.column, path);
            const PickleTags* tags = create_pickle_tags(feature->tags, scenario->tags, 0, path);
            PickleSteps* steps = (PickleSteps*)malloc(sizeof(PickleSteps));
            steps->step_count = scenario->steps->step_count + background_step_count;
            steps->steps = (PickleStep*)malloc(steps->step_count * sizeof(PickleStep));
            if (background_steps) {
                copy_steps(steps->steps, background_steps, path);
            }
            copy_steps(steps->steps + background_step_count, scenario->steps, path);
            ItemQueue_add(compiler->pickle_list, (Item*)Pickle_new(locations, tags, scenario->name, steps));
        }
        else if (feature->scenario_definitions->scenario_definitions[i]->type == Gherkin_ScenarioOutline) {
            const ScenarioOutline* scenario_outline = (const ScenarioOutline*)feature->scenario_definitions->scenario_definitions[i];
            if (scenario_outline->steps->step_count == 0) {
                continue;
            }
            int k;
            for (k = 0; k < scenario_outline->examples->example_count; ++k) {
                ExampleTable* example_table = &scenario_outline->examples->example_table[k];
                if (!example_table->table_header) {
                    continue;
                }
                const PickleTags* tags = create_pickle_tags(feature->tags, scenario_outline->tags, example_table->tags, path);
                int l;
                for (l = 0; l < example_table->table_body->row_count; ++l) {
                    const TableRow* table_row = &example_table->table_body->table_rows[l];
                    const PickleLocations* locations = PickleLocations_new_double(table_row->location.line, table_row->location.column, scenario_outline->location.line, scenario_outline->location.column, path);
                    PickleSteps* steps = (PickleSteps*)malloc(sizeof(PickleSteps));
                    steps->step_count = scenario_outline->steps->step_count +  + background_step_count;
                    steps->steps = (PickleStep*)malloc(steps->step_count * sizeof(PickleStep));
                    if (background_steps) {
                        copy_steps(steps->steps, background_steps, path);
                    }
                    int j;
                    for (j = 0; j < scenario_outline->steps->step_count; ++j) {
                        int column_offset = scenario_outline->steps->steps[j].keyword ? wcslen(scenario_outline->steps->steps[j].keyword) : 0;
                        const PickleLocations* step_locations = PickleLocations_new_double(table_row->location.line, table_row->location.column, scenario_outline->steps->steps[j].location.line, scenario_outline->steps->steps[j].location.column + column_offset, path);
                        const PickleStep* step = expand_outline_step(&scenario_outline->steps->steps[j], example_table->table_header, table_row, step_locations);
                        PickleStep_transfer(&steps->steps[background_step_count + j], (PickleStep*)step);
                    }
                    const wchar_t* new_name = create_expanded_text(scenario_outline->name, example_table->table_header, table_row);
                    ItemQueue_add(compiler->pickle_list, (Item*)Pickle_new(locations, tags, new_name, steps));
                    free((void*)new_name);
                }
            }
        }
    }
    return 0;
}

const Pickles* Compiler_get_result(Compiler* compiler) {
    if (ItemQueue_is_empty(compiler->pickle_list)) {
        return 0;
    }
    Pickles* pickles = (Pickles*)malloc(sizeof(Pickles));
    pickles->pickle_count = ItemQueue_size(compiler->pickle_list);
    pickles->pickles = (Pickle*)malloc(pickles->pickle_count * sizeof(Pickle));
    int i;
    for (i = 0; i < pickles->pickle_count; ++i) {
        Pickle_transfer(&pickles->pickles[i], (Pickle*)ItemQueue_remove(compiler->pickle_list));
    }
    return pickles;
}

static const PickleArgument* create_pickle_argument(const StepArgument* step_argument, const TableRow* example_header, const TableRow* body_row, const wchar_t* path) {
    const PickleArgument* argument = 0;
    if (step_argument) {
        if (step_argument->type == Gherkin_DataTable) {
            argument = (const PickleArgument*)create_pickle_table((DataTable*)step_argument, example_header, body_row, path);
        }
        else if (step_argument->type == Gherkin_DocString) {
            const DocString* doc_string = (DocString*)step_argument;
            if (!example_header) {
                argument = (const PickleArgument*)PickleString_new(doc_string->content, doc_string->location.line, doc_string->location.column, path);
            }
            else {
                const wchar_t* expanded_text = create_expanded_text(doc_string->content, example_header, body_row);
                argument = (const PickleArgument*)PickleString_new(expanded_text, doc_string->location.line, doc_string->location.column, path);
                free((void*)expanded_text);
            }
        }
    }
    return argument;
}

static const PickleTable* create_pickle_table(DataTable* data_table, const TableRow* example_header, const TableRow* body_row, const wchar_t* path) {
    PickleRows* rows = (PickleRows*)malloc(sizeof(PickleRows));
    rows->row_count = data_table->rows->row_count;
    rows->pickle_rows = (PickleRow*)malloc(rows->row_count * sizeof(PickleRow));
    int i;
    for (i = 0; i < rows->row_count; ++i) {
        TableRow* table_row = &data_table->rows->table_rows[i];
        PickleCells* cells = (PickleCells*)malloc(sizeof(PickleCells));
        cells->cell_count = table_row->table_cells->cell_count;
        cells->pickle_cells = (PickleCell*)malloc(cells->cell_count * sizeof(PickleCell));
        int j;
        for (j = 0; j < cells->cell_count; ++j) {
            const PickleLocation* location = PickleLocation_new(table_row->table_cells->table_cells[j].location.line, table_row->table_cells->table_cells[j].location.column, path);
            if (!example_header) {
                PickleCell_transfer(&cells->pickle_cells[j], (PickleCell*)PickleCell_new(location, table_row->table_cells->table_cells[j].value));
            }
            else {
                const wchar_t* expanded_text = create_expanded_text(table_row->table_cells->table_cells[j].value, example_header, body_row);
                PickleCell_transfer(&cells->pickle_cells[j], (PickleCell*)PickleCell_new(location, expanded_text));
                free((void*)expanded_text);
            }
        }
        PickleRow_transfer(&rows->pickle_rows[i], (PickleRow*)PickleRow_new(cells));
    }
    return PickleTable_new(rows);
}

static const PickleTags* create_pickle_tags(const Tags* source_1, const Tags* source_2, const Tags* source_3, const wchar_t* path) {
    PickleTags* tags = 0;
    int source_1_tag_count = 0;
    int source_2_tag_count = 0;
    int source_3_tag_count = 0;
    if (source_1) {
        source_1_tag_count = source_1->tag_count;
    }
    if (source_2) {
        source_2_tag_count = source_2->tag_count;
    }
    if (source_3) {
        source_3_tag_count = source_3->tag_count;
    }
    int tag_count = source_1_tag_count + source_2_tag_count + source_3_tag_count;
    if (tag_count > 0) {
        tags = (PickleTags*)malloc(sizeof(PickleTags));
        tags->tag_count = tag_count;
        tags->tags = (PickleTag*)malloc(tags->tag_count * sizeof(PickleTag));
        if (source_1) {
            copy_tags(tags->tags, source_1, path);
        }
        if (source_2) {
            copy_tags(tags->tags + source_1_tag_count, source_2, path);
        }
        if (source_3) {
            copy_tags(tags->tags + source_1_tag_count + source_2_tag_count, source_3, path);
        }
    }
    return tags;
}

static void copy_tags(PickleTag* destination_array, const Tags* source, const wchar_t* path) {
    int i;
    for (i = 0; i < source->tag_count; ++i) {
        PickleTag_transfer(destination_array + i, source->tags[i].name, source->tags[i].location.line, source->tags[i].location.column, path);
    }
}

static void copy_steps(PickleStep* destination_array, const Steps* source, const wchar_t* path) {
    int i;
    for (i = 0; i < source->step_count; ++i) {
        int column_offset = source->steps[i].keyword ? wcslen(source->steps[i].keyword) : 0;
        const PickleLocations* step_locations = PickleLocations_new_single(source->steps[i].location.line, source->steps[i].location.column + column_offset, path);
        const PickleArgument* argument = create_pickle_argument(source->steps[i].argument, 0, 0, path);
        const PickleStep* step = PickleStep_new(step_locations, source->steps[i].text, argument);
        PickleStep_transfer(destination_array + i, (PickleStep*)step);
    }
}

static const PickleStep* expand_outline_step(const Step* outline_step, const TableRow* example_header, const TableRow* body_row, const PickleLocations* locations) {
    const wchar_t* expanded_step_text = create_expanded_text(outline_step->text, example_header, body_row);
    const PickleStep* expanded_step = PickleStep_new(locations, expanded_step_text, create_pickle_argument(outline_step->argument, example_header, body_row, locations->locations[0].path));
    free((void*)expanded_step_text);
    return expanded_step;
}

static const wchar_t* create_expanded_text(const wchar_t* original_text, const TableRow* example_header, const TableRow* body_row) {
    ItemQueue* replacement_list = ItemQueue_new();
    int length = wcslen(original_text);
    int i;
    for (i = 0; i < length; ++i) {
        if (original_text[i] == L'<') {
            int j;
            for (j = 0; j < example_header->table_cells->cell_count; ++j) {
                int cell_text_length = wcslen(example_header->table_cells->table_cells[j].value);
                if (cell_text_length < length - i - 1 &&
                        wcsncmp(original_text + i + 1, example_header->table_cells->table_cells[j].value, cell_text_length) == 0) {
                    ReplacementItem* item = (ReplacementItem*)malloc(sizeof(ReplacementItem));
                    item->item_delete = (item_delete_function)ReplacementItem_delete;
                    item->start_position = i;
                    item->old_length = cell_text_length + 2;
                    item->new_text = body_row->table_cells->table_cells[j].value;
                    ItemQueue_add(replacement_list, (Item*)item);
                }
            }
        }
    }
    wchar_t* text;
    if (ItemQueue_is_empty(replacement_list)) {
        text = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(text, original_text, length);
        text[length] = L'\0';
    }
    else {
        int new_text_length = length;
        QueueItem* queue_item = replacement_list->first;
        while (queue_item) {
            ReplacementItem* item = (ReplacementItem*)queue_item->item;
            new_text_length += wcslen(item->new_text) - item->old_length;
            queue_item = queue_item->next;
        }
        text = (wchar_t*)malloc((new_text_length + 1) * sizeof(wchar_t));
        int current_src_pos = 0;
        int current_dest_pos = 0;
        while (!ItemQueue_is_empty(replacement_list)) {
            ReplacementItem* item = (ReplacementItem*)ItemQueue_remove(replacement_list);
            wmemcpy(text + current_dest_pos, original_text + current_src_pos, item->start_position - current_src_pos);
            current_dest_pos += item->start_position - current_src_pos;
            wmemcpy(text + current_dest_pos, item->new_text, wcslen(item->new_text));
            current_dest_pos += wcslen(item->new_text);
            current_src_pos += item->start_position - current_src_pos + item->old_length;
            ReplacementItem_delete(item);
        }
        if (current_src_pos < length) {
            wmemcpy(text + current_dest_pos, original_text + current_src_pos, length - current_src_pos);
        }
        text[new_text_length] = L'\0';
    }
    ItemQueue_delete(replacement_list);
    return text;
}

static void ReplacementItem_delete(ReplacementItem* item) {
    free((void*)item);
}
