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



# Intermediate