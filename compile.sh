bison -dl myparser.y
flex -iL mylexl_2.l
gcc -o microC_comp linked-list.c lex.yy.c myparser.tab.c -ll
./microC_comp < examples/example.c
