PORT=4000

.PHONY: test
test:
	@rm nohup.out
	@git add . && git commit -m "commit by makefile" && git push &

	@if lsof -i :$(PORT); then kill -9 $$(lsof -t -i :$(PORT)); fi
	@nohup hexo s &

	@sleep 2;
	@open -a "/Applications/Safari.app" 'http://localhost:$(PORT)' &

.PHONY: live
live:
	@git add . && git commit -m "commit by makefile" && git push &
	hexo clean
	hexo g -d

.DEFAULT_GOAL:= test