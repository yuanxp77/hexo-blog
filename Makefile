.PHONY: gen
gen:
	git status
	git add .
	git commit -m "commit by makefile"

.DEFAULT_GOAL:= gen