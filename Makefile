# Compiler
CC = gcc

# Files
LEX_FILE = CS315_S25_Team14.lex
YACC_FILE = CS315_S25_Team14.yacc
LEX_OUTPUT = lex.yy.c
YACC_OUTPUT = y.tab.c
YACC_HEADER = y.tab.h
EXECUTABLE = parser

# Default target
all: $(EXECUTABLE)

# Rule for generating parser
$(EXECUTABLE): $(YACC_OUTPUT) $(LEX_OUTPUT)
	$(CC) -o $(EXECUTABLE) $(YACC_OUTPUT)

# Rule for generating YACC output
$(YACC_OUTPUT) $(YACC_HEADER): $(YACC_FILE)
	yacc $(YACC_FILE)

# Rule for generating Lex output
$(LEX_OUTPUT): $(LEX_FILE)
	lex $(LEX_FILE)

# Clean up generated files
clean:
	rm -f $(EXECUTABLE) $(LEX_OUTPUT) $(YACC_OUTPUT)
