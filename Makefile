.PHONY: gen
gen:
	git add .
	git commit -m "commit by makefile"
	git push

.DEFAULT_GOAL:= gen