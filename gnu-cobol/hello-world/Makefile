.PHONY: all clean

COBC = cobc

all: hello

clean:
	rm -fv *.c *.h *.i *.o hello

hello: hello.cbl
	# -Wextra
	$(COBC) -Wall -fixed -std=default -g -debug -x -o hello hello.cbl
