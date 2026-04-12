## BASIC

# b.txt: a.txt
# 	cat a.txt > b.txt

# world:
# 	echo "Have a Great Day!" > hello.txt

# hello:
# 	ls
# 	touch hello.txt
# 	echo "Hello, World!" > hello.txt
# 	ls
# 	cat hello.txt


##  INTERMEDIATE

# main.o: main.c
# 	gcc -c main.c

# main: main.o
# 	gcc main.o -o main

# run: main
# 	./main

# clean:
# 	rm main main.o

## VARIABLES

# C_FILES = main.c msg.c

# main: $(C_FILES)
# 	gcc $(C_FILES) -o main

# run: main
# 	./main

# clean:
# 	rm main

## PATERN

# OBJ_FILES = main.o msg.o

# main: $(OBJ_FILES)
# 	gcc $(OBJ_FILES) -o main

# # PATTERN RULE
# # %: Wildcard
# # $^: $ - Variable, ^ - All Dependencies
# # $<: $ - Variable, < - First Dependencies

# %.o: %.c
# 	gcc -c $^

# run: main
# 	./main

# clean:
# 	rm main main.o msg.o


# # $@: @ - Target 

# SRC = main.c msg.c
# OBJ_FILES = $(SRC:%.c=%.o) 
# # pattern substitution - patsubst : explanation -

# PAT_SUBST = $(patsubst %.c, %.o, $(SRC))
# # same functionality

# $(info $(SRC) $(PAT_SUBST)) # For Debugging

# main: $(OBJ_FILES)
# 	gcc $(OBJ_FILES) -o main

# %.o: %.c
# # 	gcc -c $^
# 	gcc -c $< -o $@

# run: main
# 	./main

# clean:
# 	rm -f main $(OBJ_FILES)


# Executing shell command
# SRC = $(shell find -iname "*.c")
# When file is renamed this solves the hassle of edit file

# HELLO ?= 2

# $(info Value of HELLO is $(HELLO))


# SRC = hello.c
# $(info Source file is $(SRC))
# SRC = world.c
# $(info Source file is $(SRC))


# SRC = hello.c
# $(info Source file is $(SRC))
# SRC += world.c
# $(info Source file is $(SRC))

# define msg
# 	echo "msg "
# 	echo "msg from " $@
# endef

# one:
# 	$(info $(msg))

# two:
# 	$(info $(msg))