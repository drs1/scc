CFLAGS 				:= -Wall -g
BIN_DIR				:= bin
SRC_DIR				:= src
LEX					:= lex
PARSE				:= parse
SCC					:= scc

PARSE_B             := $(addprefix $(BIN_DIR)/,$(PARSE))
SCC_B               := $(addprefix $(BIN_DIR)/,$(SCC))


PARSE_S             := $(addprefix $(SRC_DIR)/,$(PARSE))
SCC_S               := $(addprefix $(SRC_DIR)/,$(SCC))

MODULES 			:= $(LEX) $(PARSE) $(SCC)
SRC_DIRS 			:= $(addprefix $(SRC_DIR)/,$(MODULES))
BIN_DIRS			:= $(addprefix $(BIN_DIR)/,$(MODULES))
MKFILES				:= $(addsuffix /Makefile, $(SRC_DIRS))

include	$(MKFILES)

PARSE_OBJS			:= $(addprefix $(PARSE_B)/,$(PARSE_OBJ))
SCC_OBJS			:= $(addprefix $(SCC_B)/,$(SCC_OBJ))

OBJS 				:= $(LEX_OBJS) $(PARSE_OBJS) $(SCC_OBJS)


# autogen from flex before anything
all scc: src/lex/lex.c $(OBJS) | $(BIN_DIRS)

$(OBJS)	:  | $(BIN_DIRS)

#files for the lexer
$(LEX_B)/%.o : $(LEX_S)/%.c
	@echo Creating $@
	cc $(CFLAGS) -o $@ -c $<

#special rule for autgenning from flex
$(LEX_S)/lex.c: $(LEX_S)/c.flex
	@echo Creating $@
	flex -o src/lex/lex.c $(LEX_S)/c.flex

$(BIN_DIRS): 
	@echo Creating $@ directory
	@mkdir -p $@

clean:
	rm -rf bin
	rm -rf src/lex/lex.c
