b.txt: a.txt
	cat a.txt > b.txt

world:
	echo "Have a Great Day!" > hello.txt

hello:
	ls
	touch hello.txt
	echo "Hello, World!" > hello.txt
	ls
	cat hello.txt