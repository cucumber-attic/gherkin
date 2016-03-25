#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <locale.h>
#include <wchar.h>

#include "token_scanner.h"
#include "token_matcher.h"
#include "parser.h"
#include "ast_builder.h"
#include "compiler.h"
#include "pickle_printer.h"

int main(int argc, char** argv) {
    setlocale(LC_ALL, "");
    TokenMatcher* token_matcher = TokenMatcher_new(L"en");
    Builder* builder = AstBuilder_new();
    Parser* parser = Parser_new(builder);
    Compiler* compiler = Compiler_new();
    const Feature* feature;
    const Pickles* pickles;
    int result_code = 0;
    int i;
    for (i = 1; i < argc; ++i) {
        TokenScanner* token_scanner = TokenScanner_new(argv[i]);
        result_code = Parser_parse(parser, token_matcher, token_scanner);
        if (result_code == 0) {
            feature = AstBuilder_get_result(builder);
            int length = strlen(argv[i]) + 1;
            wchar_t* path = malloc(length * sizeof(wchar_t));
            swprintf(path, length, L"%hs", argv[i]);
            result_code = Compiler_compile(compiler, feature, path);
            if (result_code == 0) {
                pickles = Compiler_get_result(compiler);
                PicklePrinter_print_pickles(stdout, pickles);
                Pickles_delete(pickles);
            }
            Feature_delete(feature);
        }
        else {
            fprintf(stderr, "Compiler errors:\n");
            while (Parser_has_more_errors(parser)) {
                fprintf(stderr, "%ls\n", Parser_next_error(parser));
            }
        }
        TokenScanner_delete(token_scanner);
    }
    Compiler_delete(compiler);
    Parser_delete(parser);
    AstBuilder_delete(builder);
    TokenMatcher_delete(token_matcher);
    return result_code;
}
