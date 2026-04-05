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
