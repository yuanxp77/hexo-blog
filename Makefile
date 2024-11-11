.PHONY: gen
gen:
	git add .
	git commit -m "commit by makefile"
	git push
	hexo g -d
	hexo s

.DEFAULT_GOAL:= gen