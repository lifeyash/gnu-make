SRC = $(shell find . -iname "*.c")
OBJ_FILES = $(patsubst %.c, %.o, $(SRC))
INCLUDES = $(shell find . -iname "*.h" -exec dirname {} \; | sort -u | sed 's/^/-I/' | xargs)

$(info $(SRC) $(OBJ_FILES) $(INCLUDES))

main: $(OBJ_FILES)
	gcc $^ -o $@

%.o: %.c
	gcc $(INCLUDES) -c $< -o $@

run: main
	./main

clean:
	@rm -f main $(OBJ_FILES)