.PHONY:
1:
	(racket main.rkt 2>&1 | cat > pipe &) &
.PHONY:
3:
	pkill main.rkt
