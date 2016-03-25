CC=gcc
CC_FLAGS=-c -Wall
GENERATE_DEPS_FLAGS=-MMD -MF $(basename $@).d
AR=ar
AR_FLAGS=cr
LD=gcc
LD_FLAGS=
LD_LIBS=
RM_CMD=rm -rf
MKDIR_CMD=mkdir -p

all: \
	../bin/gherkin_generate_tokens \
	../bin/gherkin_generate_ast \
	../bin/gherkin_generate_pickles

libs: ../libs/libgherkin.a

clean:
	$(RM_CMD) ../bin ../objs ../libs
.PHONY: clean

PARSER_OBJS= \
	../objs/parser.o \
	../objs/token_scanner.o \
	../objs/token_matcher.o \
	../objs/token.o \
	../objs/token_queue.o \
	../objs/item_queue.o \
	../objs/gherkin_line.o \
	../objs/error.o \
	../objs/error_list.o \
	../objs/dialect.o
-include $(PARSER_OBJS:.o=.d)

AST_OBJS= \
	../objs/ast_builder.o \
	../objs/ast_node.o \
	../objs/feature.o \
	../objs/scenario.o \
	../objs/scenario_outline.o \
	../objs/background.o \
	../objs/comment.o \
	../objs/data_table.o \
	../objs/doc_string.o \
	../objs/example_table.o \
	../objs/step.o \
	../objs/table_cell.o \
	../objs/table_row.o \
	../objs/tag.o 
-include $(AST_OBJS:.o=.d)

COMPILER_OBJS= \
	../objs/compiler.o
-include $(COMPILER_OBJS:.o=.d)

PICKLES_OBJS= \
	../objs/pickle.o \
	../objs/pickle_cell.o \
	../objs/pickle_location.o \
	../objs/pickle_row.o \
	../objs/pickle_step.o \
	../objs/pickle_string.o \
	../objs/pickle_table.o \
	../objs/pickle_tag.o
-include $(PICKLES_OBJS:.o=.d)

GENERATE_TOKEN_OBJS= \
	../objs/token_formatter_builder.o \
	../objs/gherkin_generate_tokens.o
-include $(GENERATE_TOKEN_OBJS:.o=.d)

GENERATE_AST_OBJS= \
	../objs/ast_printer.o \
	../objs/gherkin_generate_ast.o
-include $(GENERATE_AST_OBJS:.o=.d)

GENERATE_PICKLES_OBJS= \
	../objs/pickle_printer.o \
	../objs/gherkin_generate_pickles.o
-include $(GENERATE_PICKLES_OBJS:.o=.d)

../objs/%.o: %.c Makefile
	$(MKDIR_CMD) $(dir $@)
	$(CC) $(CC_FLAGS) $(GENERATE_DEPS_FLAGS) -I . $< -o $@

../libs/libgherkin.a: $(PARSER_OBJS) $(AST_OBJS) $(COMPILER_OBJS) $(PICKLES_OBJS)
	$(MKDIR_CMD) $(dir $@)
	$(AR) $(AR_FLAGS) $@ $(PARSER_OBJS) $(AST_OBJS) $(COMPILER_OBJS) $(PICKLES_OBJS)

../bin/gherkin_generate_tokens: ../libs/libgherkin.a $(GENERATE_TOKEN_OBJS) Makefile
	$(MKDIR_CMD) $(dir $@)
	$(LD) $(LD_FLAGS) $(GENERATE_TOKEN_OBJS) -L../libs/ -lgherkin $(LD_LIBS) -o $@

../bin/gherkin_generate_ast: ../libs/libgherkin.a $(GENERATE_AST_OBJS) Makefile
	$(MKDIR_CMD) $(dir $@)
	$(LD) $(LD_FLAGS) $(GENERATE_AST_OBJS) -L../libs/ -lgherkin $(LD_LIBS) -o $@

../bin/gherkin_generate_pickles: ../libs/libgherkin.a $(GENERATE_PICKLES_OBJS) Makefile
	$(MKDIR_CMD) $(dir $@)
	$(LD) $(LD_FLAGS) $(GENERATE_PICKLES_OBJS) -L../libs/ -lgherkin $(LD_LIBS) -o $@
