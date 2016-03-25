#include "token.h"
#include <stdlib.h>

Token* Token_new(const GherkinLine* gherkin_line, int line) {
    Token* token = (Token*)malloc(sizeof(Token));
    token->token_delete = (item_delete_function)Token_delete;
    token->line = gherkin_line;
    token->location.line = line;
    token->location.column = 0;
    token->matched_text = 0;
    token->matched_keyword = 0;
    token->matched_items = 0;
    token->matched_language = 0;
    return token;
}

void Token_delete(Token* token) {
    if (!token) {
        return;
    }
    if (token->line)
        free((void*)token->line);
    if (token->matched_text)
        free((void*)token->matched_text);
    if (token->matched_items) {
        int i;
        for (i = 0; i < token->matched_items->count; ++i) {
            if (token->matched_items->items[i].text) {
                free((void*)token->matched_items->items[i].text);
            }
        }
        free((void*)token->matched_items);
    }
    free((void*)token);
}

bool Token_is_eof(Token* token) {
    return !token->line;
}
