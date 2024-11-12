.PHONY: test
test:
	git add .
	git commit -m "commit by makefile"
	git push
	kill -9 4000
	nohup hexo s 
	open -a "/Applications/Safari.app" 'http://localhost:4000'


.PHONY: live
live:
	git add .
	git commit -m "commit by makefile"
	git push
	hexo g -d

.DEFAULT_GOAL:= test