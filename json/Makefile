json1:	json.l json.y
	bison -d json.y
	flex json.l
	cc -o $@ json.tab.c lex.yy.c -ll	
