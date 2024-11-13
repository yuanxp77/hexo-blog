---
title: 一种写Hexo博客的姿势
date: 2024-11-11 20:23:11
tags:
---

在你的博客工程下新建一个叫`Makefile`的文件，为其添加以下内容：

``` makefile
PORT=4000

.PHONY: test
test:
	@git add . && git commit -m "commit by makefile" && git push &

	@if lsof -i :$(PORT); then kill -9 $$(lsof -t -i :$(PORT)); fi
	@nohup hexo g &
	@nohup hexo s &

	@sleep 2;
	@open -a "/Applications/Safari.app" 'http://localhost:$(PORT)' &

.PHONY: live
live:
	@git add . && git commit -m "commit by makefile" && git push &
	hexo clean
	hexo g -d

.DEFAULT_GOAL:= test
```