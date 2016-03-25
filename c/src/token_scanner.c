#include "token_scanner.h"
#include "gherkin_line.h"
#include <stdlib.h>
#include <stdio.h>
#include <wchar.h>

typedef struct FileTokenScanner {
    TokenScanner token_scanner;
    int line;
    FILE* file;
    int buffer_size;
    wchar_t* buffer;
} FileTokenScanner;

Token* TokenScanner_read(TokenScanner* token_scanner);

static wchar_t read_wchar_from_file(FILE* file);

TokenScanner* TokenScanner_new(const char* const file_name) {
    FileTokenScanner* token_scanner = (FileTokenScanner*)malloc(sizeof(FileTokenScanner));
    token_scanner->token_scanner.read = &TokenScanner_read;
    token_scanner->line = 0;
    token_scanner->file = 0;
    token_scanner->file = fopen(file_name, "r");
    token_scanner->buffer_size = 128;
    token_scanner->buffer = (wchar_t*)malloc(token_scanner->buffer_size * sizeof(wchar_t));
    return (TokenScanner*) token_scanner;
}

void TokenScanner_delete(TokenScanner* token_scanner) {
    if (!token_scanner) {
        return;
    }
    FileTokenScanner* file_token_scanner = (FileTokenScanner*)token_scanner;
    if (file_token_scanner->file)
        fclose(file_token_scanner->file);
    free((void*)file_token_scanner->buffer);
    free((void*)file_token_scanner);
}

Token* TokenScanner_read(TokenScanner* token_scanner) {
    FileTokenScanner* file_token_scanner = (FileTokenScanner*)token_scanner;
    ++file_token_scanner->line;
    if (!file_token_scanner->file)
        return Token_new(0, file_token_scanner->line);
    if (feof(file_token_scanner->file))
        return Token_new(0, file_token_scanner->line);
    int pos = 0;
    wchar_t c;
    do {
        c = read_wchar_from_file(file_token_scanner->file);
        if (c != WEOF && c != L'\r' && c != L'\n') {
            file_token_scanner->buffer[pos++] = c;
            if (pos >= file_token_scanner->buffer_size - 1) {
                file_token_scanner->buffer_size *= 2;
                file_token_scanner->buffer = (wchar_t*)realloc(file_token_scanner->buffer, file_token_scanner->buffer_size * sizeof(wchar_t));
            }
        }
    } while (c != WEOF && c != L'\n');
    file_token_scanner->buffer[pos] = L'\0';
    const GherkinLine* line;
    if (c != EOF || pos != 0) {
        wchar_t* text = (wchar_t*)malloc((pos + 1) * sizeof(wchar_t));
        wmemcpy(text, file_token_scanner->buffer, pos);
        text[pos] = L'\0';
        line = GherkinLine_new(text, file_token_scanner->line);
    }
    else
        line = (GherkinLine*)0;
    return Token_new(line, file_token_scanner->line);
}

static wchar_t read_wchar_from_file(FILE* file) {
    unsigned char c = fgetc(file);
    if (c < 0x80) {
        return (wchar_t)c;
    }
    unsigned char c2 = fgetc(file);
    wchar_t lower_part = (wchar_t)(c2 & 0x3F);
    if ((c & 0xE0) == 0xC0) {
        return (((wchar_t)(c & 0x1F)) << 6) | lower_part;
    }
    c2 = fgetc(file);
    lower_part =  (lower_part << 6) | (wchar_t)(c2 & 0x3F);
    if ((c & 0xF0) == 0xE0) {
        return (((wchar_t)(c & 0x0F)) << 12) | lower_part;
    }
    c2 = fgetc(file);
    lower_part =  (lower_part << 6) | (wchar_t)(c2 & 0x3F);
    if ((c & 0xF8) == 0xF0) {
        return (((wchar_t)(c & 0x07)) << 18) | lower_part;
    }
    c2 = fgetc(file);
    lower_part =  (lower_part << 6) | (wchar_t)(c2 & 0x3F);
    if ((c & 0xFC) == 0xF8) {
        return (((wchar_t)(c & 0x03)) << 24) | lower_part;
    }
    c2 = fgetc(file);
    lower_part =  (lower_part << 6) | (wchar_t)(c2 & 0x3F);
    if ((c & 0xFE) == 0xFC) {
        return (((wchar_t)(c & 0x01)) << 30) | lower_part;
    }
    return WEOF;
}
