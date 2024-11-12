.PHONY: test
test:
	git add .
	git commit -m "commit by makefile"
	git push
	open -a "/Applications/Safari.app" 'http://localhost:4000'
	hexo s


.PHONY: live
live:
	git add .
	git commit -m "commit by makefile"
	git push
	hexo g -d

.DEFAULT_GOAL:= test