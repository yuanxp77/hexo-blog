PORT=4000

.PHONY: test
test:
	@git add . && git commit -m "commit by makefile" && git push &

	@if lsof -i :$(PORT); then kill -9 $$(lsof -t -i :$(PORT)); fi
	@nohup hexo g &
	@nohup hexo s &

	cd ./public/melon/ && chmod +x generate.sh && ./generate.sh
	cd ./public/static/ && chmod +x generate.sh && ./generate.sh

	@sleep 2;
	@open -a "/Applications/Safari.app" 'http://localhost:$(PORT)' &

.PHONY: live
live:
	@git add . && git commit -m "commit by makefile" && git push &
	hexo g -d

.DEFAULT_GOAL:= test