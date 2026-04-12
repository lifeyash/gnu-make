# GNU Make

# Basics

## 1. Makefile Name

* File must be named exactly:

  ```
  Makefile
  ```
* Capital **M** is required

---

## 2. Running Make

```bash
make
```

### If no target exists:

```bash
make: *** No targets. Stop.
```

Meaning: your Makefile has no valid targets

---

## 3. Basic Makefile Example

```make
hello:
	ls
	touch hello.txt
	echo "Hello, World!" > hello.txt
	ls
	cat hello.txt
```

---

## 4. Key Terms

### Target

```make
hello:
```

* Name of the task

### Recipe (commands)

```make
	ls
	touch hello.txt
	echo "Hello, World!" > hello.txt
	ls
	cat hello.txt
```

* Commands executed for the target

---

## 5. Important Rule

* Recipes must:

  * Start on the next line after the target
  * Begin with a TAB (not spaces)

---

## 6. Example Output

```bash
$ make
ls
LICENSE  Makefile  README.md
touch hello.txt
echo "Hello, World!" > hello.txt
ls
LICENSE  Makefile  README.md  hello.txt
cat hello.txt
Hello, World!
```

---

## 7. Multiple Targets

```make
hello:
	ls
	touch hello.txt

world:
	echo "World"
```

Run specific target:

```bash
make hello
make world
```

---

## 8. Dependencies

```make
b.txt: a.txt
	cat a.txt > b.txt
```

* `b.txt` depends on `a.txt`
* The recipe runs only if:

  * `b.txt` doesn’t exist, or
  * `a.txt` is newer than `b.txt`

## Execution detail

For the command:

```sh
cat a.txt > b.txt
```

The shell:

1. Opens `b.txt` and truncates it
2. Runs `cat a.txt` and writes into `b.txt`

## Important edge case

If input and output are the same file:

```sh
cat a.txt > a.txt
```

* File is truncated before reading
* Result: empty file

## Multiple dependencies

```make
out.txt: a.txt b.txt
	cat a.txt b.txt > out.txt
```

Rebuilds if either dependency changes.


---

# Intermediate

## Example

```make
main.o: main.c
	gcc -c main.c

main: main.o
	gcc main.o -o main

run: main
	./main

clean:
	rm main main.o
```

---

## What each part does

**Compile**

```make
main.o: main.c
	gcc -c main.c
```

* Creates `main.o` from `main.c`
* `-c` = compile only

**Link**

```make
main: main.o
	gcc main.o -o main
```

* Creates executable `main`

**Run**

```make
run: main
	./main
```

* Builds if needed, then runs

**Clean**

```make
clean:
	rm main main.o
```

* Deletes generated files

---

## Commands

```bash
make        # builds main (first target)
make run    # builds + runs
make clean  # removes files
```

---

## `-n` Flag (Dry Run)

```bash
make -n
```

* Shows commands without executing them
* Useful for debugging Makefile

Example:

```bash
make -n run
```

* Prints what would run for `run` target without actually running it

---

# Intermediate

## Using Variables

```make
C_FILES = main.c msg.c

main: $(C_FILES)
	gcc $(C_FILES) -o main

run: main
	./main

clean:
	rm main
```

---

## Variable Use

```make
C_FILES = main.c msg.c
```

* Stores list of source files

```make
$(C_FILES)
```

* Expands to `main.c msg.c`

---

## Notes

* Direct compile + link
* Any file change rebuilds everything
* Good for small projects

---

## Commands

```bash
make
make run
make clean
make -n
```
Continuing, cleaned and minimal.

---

## Pattern Rule

```make
OBJ_FILES = main.o msg.o

main: $(OBJ_FILES)
	gcc $(OBJ_FILES) -o main

# PATTERN RULE
# %  : wildcard
# $^ : all dependencies

%.o: %.c
	gcc -c $^

run: main
	./main

clean:
	rm main main.o msg.o
```

---

## What this does

```make
%.o: %.c
```

* Rule for any `.c` → `.o`
* Example:

  * `main.c` → `main.o`
  * `msg.c` → `msg.o`

---

## Automatic Variable

```make
$^
```

* Expands to all dependencies
* Here: the matching `.c` file

---

## Build Flow

```bash
make
```

* Builds:

  * `main.o` from `main.c`
  * `msg.o` from `msg.c`
  * Links → `main`

---

## Notes

* Enables incremental build
* Only changed `.c` files are recompiled
* Scales better than direct compile

## Better form (recommended)

```make
%.o: %.c
	gcc -c $< -o $@
```

* `$<` = first dependency (`.c`)
* `$@` = target (`.o`)

---

Continuing with small additions for recall.

---

# Intermediate

## Pattern Substitution

```make
# $@ : target

SRC = main.c msg.c

OBJ_FILES = $(SRC:%.c=%.o)
# pattern substitution

PAT_SUBST = $(patsubst %.c, %.o, $(SRC))
# same as above

$(info $(SRC) $(PAT_SUBST)) # debug

main: $(OBJ_FILES)
	gcc $(OBJ_FILES) -o main

%.o: %.c
	gcc -c $^

run: main
	./main

clean:
	rm -f main $(OBJ_FILES)

all:
	@echo "This prints when 'all' is executed"
```

---

## Pattern Substitution

```make
$(SRC:%.c=%.o)
```

* Replace `.c` → `.o` for each file
* Fast shorthand

```make
$(patsubst %.c, %.o, $(SRC))
```

* Same, readable form
* Use when pattern is complex

---

## Automatic Variables (core)

* `$@` → target (what you are building)
* `$^` → all dependencies
* `$<` → first dependency (used in compile rules)

---

## Pattern Rule

```make
%.o: %.c
```

* Generic rule
* Applies to all matching files
* Avoids writing rules per file

---


* `$<` ensures correct input file
* `$@` ensures correct output name
* More precise than `$^`

---

## Debugging

```make
$(info ...)
```

* Runs at parse time (before execution)
* Good for checking variable expansion

---

## Build Flow

```bash
make
```

* Expands `SRC`
* Generates `OBJ_FILES`
* Builds `.o` files using pattern rule
* Links → `main`

---

## Notes

* Fully scalable structure
* Add/remove `.c` → auto handled
* Supports incremental build

---

## Commands

```bash
make
make run
make clean
make -n
```

---

## Auto Source + Include Discovery

```make id="d9a0v0"
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
	rm -f main $(OBJ_FILES)
```

---

## What this pattern does

* Auto finds all `.c` files
* Converts to `.o`
* Auto finds header directories → builds `-I` flags
* Compiles and links

---

## Key Expansions

```make id="7x19qo"
SRC        → ./src/main.c
OBJ_FILES  → ./src/main.o
INCLUDES   → -I./include/magic -I./include/magic2
```

---

## Shell Breakdown

### SRC

```sh id="6i6k4v"
find . -iname "*.c"
```

* Search recursively for `.c` files

---

### INCLUDES pipeline

```sh id="gfe56k"
find . -iname "*.h"
```

* find header files

```sh id="7hhfrs"
-exec dirname {} \;
```

* get directory of each header

```sh id="mj1yju"
sort -u
```

* remove duplicates

```sh id="uxbq1m"
sed 's/^/-I/'
```

* prefix `-I`

```sh id="qgk8vd"
xargs
```

* merge into single line

Final:

```sh id="4q46j6"
-I./include/magic -I./include/magic2
```

---

## Notes

* `$^` → all `.o` files
* `$<` → current `.c` file
* `$(info ...)` → prints values before execution

---

## Commands

```bash id="g3dt2u"
make
make run
make clean
make -n
```

---

## Passing Values from Command Line

```make id="xk0z1v"
HELLO =

$(info Value of HELLO is $(HELLO))
```

```bash id="c2h4qf"
make HELLO=hello
```

Output:

```bash id="0q1l8v"
Value of HELLO is hello
```

---

## Default Value (`?=`)

```make id="xqk2e9"
HELLO ?= 1

$(info Value of HELLO is $(HELLO))
```

```bash id="7p1q5n"
make HELLO=2
```

* Output:

```bash id="3l7yqk"
Value of HELLO is 2
```

```bash id="v0m3k2"
make
```

* Output:

```bash id="h2f9s1"
Value of HELLO is 1
```

---

## Use Case (Compiler Selection)

```make id="p8n3t4"
GCC ?= gcc

$(info Compiler is $(GCC))
```

```bash id="r6m1c9"
make GCC=arm-none-eabi-gcc
```

Output:

```bash id="u3b7w2"
Compiler is arm-none-eabi-gcc
```

---

## Variable Override Behavior

* `=` → always assign
* `?=` → assign only if not already set

---

## Append (`+=`)

### Overwrite

```make id="d9m2k1"
SRC = hello.c
$(info Source file is $(SRC))

SRC = world.c
$(info Source file is $(SRC))
```

Output:

```bash id="y4t8n6"
Source file is hello.c
Source file is world.c
```

---

### Append

```make id="k1p9v3"
SRC = hello.c
$(info Source file is $(SRC))

SRC += world.c
$(info Source file is $(SRC))
```

Output:

```bash id="z8r2x5"
Source file is hello.c
Source file is hello.c world.c
```

---

## Notes

* Command line variables override Makefile variables
* `?=` is useful for configurable defaults
* `+=` appends to existing value instead of replacing

---

## Commands

```bash id="n5c2x7"
make
make HELLO=hello
make GCC=arm-none-eabi-gcc
make -n
```


Clean and minimal.

---

## Multiline Variable (`define`)

```make id="q7xk2v"
define msg
	echo "msg "
	echo "msg from " $@
endef

one:
	$(info $(msg))

two:
	$(info $(msg))
```

---

## What this does

* `define ... endef` → multiline variable
* `$(msg)` expands to multiple lines

---

## Important

* `$(info ...)` prints text only
* Does NOT execute shell commands

So output is just:

```text
echo "msg "
echo "msg from " one
```

---

## Correct way (to execute)

```make id="m2k9d1"
one:
	$(msg)

two:
	$(msg)
```

---

## Notes

* `$@` → current target (`one`, `two`)
* Use `define` for reusable command blocks
* Use inside recipe, not `$(info)` for execution
