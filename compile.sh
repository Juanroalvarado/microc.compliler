bison -dl myparser.y
flex -iL mylexl_2.l
gcc -o microC_comp lex.yy.c myparser.tab.c -ll
./microC_comp < examples/example.c
