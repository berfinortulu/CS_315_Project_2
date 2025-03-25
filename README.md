# CS315 Project 2: DB++

This repository contains the second project of CS315 - Programming Languages (Spring 2025), where we implemented a syntax parser for our own programming language: **DB++**.

##  Team Members
- **Berfin Örtülü** – 21802704  
- **Ufuk Baran Güler** – 22001734  
- **Defne Lal Oruncak** – 22201809  
(Section 1)

##  Project Overview

DB++ is a custom-designed, real-number-oriented programming language focused on mathematical computation and numerical precision. It supports:

- Variable and array declarations (`REAL`)
- Control structures: `if`, `elif`, `else`, `while`, `do-while`, `for`, `for_each`
- Pass-by-value and pass-by-reference functions
- Arithmetic and boolean expressions
- User input/output handling
- Comments (single-line and multi-line)

The project consists of the following phases:
- **Lexical Analysis** using `lex`
- **Syntax Parsing** using `yacc`

##  How to Run

1. Compile the lexer and parser:

```bash
flex dbpp.l
bison -d dbpp.y
gcc lex.yy.c dbpp.tab.c -o dbpp
