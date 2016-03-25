#include "pickle_printer.h"
#include "pickle_string.h"
#include "pickle_table.h"
#include <wchar.h>
#include <stdlib.h>

static void print_location(FILE* file, const PickleLocation* location) {
    fprintf(file, "{\"line\":%d,", location->line);
    fprintf(file, "\"column\":%d,", location->column);
    fprintf(file, "\"path\":\"%ls\"}", location->path);
}

static void print_locations(FILE* file, const PickleLocations* locations) {
    fprintf(file, "\"locations\":[");
    if (locations) {
        int i;
        for (i = 0; i < locations->location_count; ++i) {
            if (i > 0) {
                fprintf(file, ",");
            }
            print_location(file, &locations->locations[i]);
        }
    }
    fprintf(file, "],");
}

static void print_json_string(FILE* file, const wchar_t* text) {
    int i;
    for (i = 0; i < wcslen(text); ++i) {
        if (text[i] == L'\\' || text[i] == L'"') {
            fprintf(file, "%lc", (wint_t)L'\\');
            fprintf(file, "%lc", (wint_t)text[i]);
        }
        else if (text[i] == L'\n') {
            fprintf(file, "%lc", (wint_t)L'\\');
            fprintf(file, "%lc", (wint_t)L'n');
        }
        else {
            fprintf(file, "%lc", (wint_t)text[i]);
        }
    }
}

static void print_table_cell(FILE* file, const PickleCell* pickle_cell) {
    fprintf(file, "{\"location\": ");
    print_location(file, pickle_cell->location);
    fprintf(file, ",\"value\": \"");
    print_json_string(file, pickle_cell->value);
    fprintf(file, "\"");
    fprintf(file, "}");
}

static void print_table_row(FILE* file, const PickleRow* pickle_row) {
    fprintf(file, "{\"cells\":[");
    int i;
    for (i = 0; i < pickle_row->pickle_cells->cell_count; ++i) {
        if (i > 0) {
            fprintf(file, ",");
        }
        print_table_cell(file, &pickle_row->pickle_cells->pickle_cells[i]);
    }
    fprintf(file, "]}");
}

static void print_pickle_table(FILE* file, const PickleTable* pickle_table) {
    fprintf(file, "{\"rows\":[");
    int i;
    for (i = 0; i < pickle_table->rows->row_count; ++i) {
        if (i > 0) {
            fprintf(file, ",");
        }
        print_table_row(file, &pickle_table->rows->pickle_rows[i]);
    }
    fprintf(file, "]}");
}

static void print_pickle_string(FILE* file, const PickleString* pickle_string) {
    fprintf(file, "{\"location\": ");
    print_location(file, &pickle_string->location);
    fprintf(file, ",\"content\":\"");
    if (pickle_string->content) {
        print_json_string(file, pickle_string->content);
    }
    fprintf(file, "\"}");
}

static void print_tag(FILE* file, const PickleTag* tag) {
    fprintf(file, "{\"location\":");
    print_location(file, &tag->location);
    fprintf(file, ",\"name\":\"%ls\"}", tag->name);
}

static void print_pickle_step(FILE* file, const PickleStep* step) {
    fprintf(file, "{");
    print_locations(file, step->locations);
    fprintf(file, "\"arguments\" : [");
    if (step->argument) {
        if (step->argument->type == Argument_String) {
            print_pickle_string(file, (const PickleString*)step->argument);
        }
        if (step->argument->type == Argument_Table) {
            print_pickle_table(file, (const PickleTable*)step->argument);
        }
    }
    fprintf(file, "],");
    fprintf(file, "\"text\":\"%ls\"", step->text);
    fprintf(file, "}");
}

static void print_pickle(FILE* file, const Pickle* pickle) {
    fprintf(file, "{");
    fprintf(file, "\"name\" : \"");
    print_json_string(file, pickle->name);
    fprintf(file, "\",");
    print_locations(file, pickle->locations);
    fprintf(file, "\"tags\":[");
    if (pickle->tags) {
        int i;
        for (i = 0; i < pickle->tags->tag_count; ++i) {
            if (i > 0) {
                fprintf(file, ",");
            }
            print_tag(file, &pickle->tags->tags[i]);
        }
    }
    fprintf(file, "],");
    fprintf(file, "\"steps\":[");
    if (pickle->steps) {
        int i;
        for (i = 0; i < pickle->steps->step_count; ++i) {
            if (i > 0) {
                fprintf(file, ",");
            }
            print_pickle_step(file, &pickle->steps->steps[i]);
        }
    }
    fprintf(file, "]");
    fprintf(file, "}");
}

void PicklePrinter_print_pickles(FILE* file, const Pickles* pickles) {
    fprintf(file, "[");
    if (pickles) {
        int i;
        for (i = 0; i < pickles->pickle_count; ++i) {
            if (i > 0) {
                fprintf(file, ",");
            }
            print_pickle(file, &pickles->pickles[i]);
        }
    }
    fprintf(file, "]\n");
}
