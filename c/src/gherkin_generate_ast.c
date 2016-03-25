#include <stdio.h>
#include <locale.h>
#include "token_scanner.h"
#include "token_matcher.h"
#include "parser.h"
#include "ast_builder.h"
#include "ast_printer.h"

int main(int argc, char** argv) {
    setlocale(LC_ALL, "");
    int result_code = 0;
    int i;
    TokenMatcher* token_matcher = TokenMatcher_new(L"en");
    Builder* builder = AstBuilder_new();
    Parser* parser = Parser_new(builder);
    const Feature* feature;
    for (i = 1; i < argc; ++i) {
        TokenScanner* token_scanner = TokenScanner_new(argv[i]);
        result_code = Parser_parse(parser, token_matcher, token_scanner);
        if (result_code == 0) {
            feature = AstBuilder_get_result(builder);
            AstPrinter_print_feature(stdout, feature);
            Feature_delete(feature);
        }
        else {
            fprintf(stderr, "Parser errors:\n");
            while (Parser_has_more_errors(parser)) {
                fprintf(stderr, "%ls\n", Parser_next_error(parser));
            }
        }
        TokenScanner_delete(token_scanner);
    }
    Parser_delete(parser);
    AstBuilder_delete(builder);
    TokenMatcher_delete(token_matcher);
    return result_code;
}
