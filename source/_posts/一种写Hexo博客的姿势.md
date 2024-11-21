---
title: 一种写Hexo博客的姿势
date: 2024-11-11 20:23:11
tags: 轻松一下
---

## 写在前面

> 本文旨在介绍一种技巧来简化使用hexo的一些步骤，使我们能专注于写文章的过程，提高效率。博主用的是macos，部分内容其他系统可能不适用，需要自行探索（doge）。

首先我想介绍一个工具，叫makefile。什么是makefile？或许一些平时使用ide的程序员不太了解这个东西，因为它的主要能力——构建，已经融入了ide。在这篇博客里，我们只需要知道它可以将多行的命令打包成一句，然后执行。本文不会展开讲makefile的教学，只从当前的使用场景来讲讲我自己的用法和理解，抛砖引玉（大佬如有意见，可在文章底部留言）。

展开学习makefile可参考：https://liaoxuefeng.com/books/makefile/makefile-basic/index.html



## 使用前

正常来说，使用hexo写一篇博客，需要以下步骤：

1. `hexo new blog-title`开一篇新博客
2. 哼哧哼哧开始写
3. `hexo g`生成一下博客内容
4. `hexo s`并且打开浏览器，输入`http://localhost:4000`进行预览
5. `hexo d`发布
6. （如有）除了发布hexo博客本身之外，hexo博客工程也要在github等远端上做备份，需要`git add, commit, push`

**现在我说，后面四步都可以一行指令解决，并且很简单。**



## 如何使用

### 准备

- 已经能使用上面提到的命令，正常使用hexo

- 为你本地的hexo博客工程也在代码托管平台（github等）创建一个仓库（建议为私有的），并能够git push

- 检查makefile环境：`make -v`，如果没有版本信息等，则需要安装，参考：

  - Linux：`sudo apt install build-essential`

  - Maxos：`brew install make gcc`

  - Windows：参考 https://tehub.com/a/aCYp1uw0tG

    - 渠道1，从官网下载 make.exe Make for Windows

      官网首页：https://www.gnu.org/software/make/

      下载地址：https://gnuwin32.sourceforge.net/downlinks/make.php

      完整安装后。把安装路径添加到环境变量 PATH 中.

    - 渠道2，参考chocolaty官网安装chocolatey

      https://community.chocolatey.org/packages/make

      管理员运行power shell

      ```shell
      Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
      ```

      接着在power shell中键入如下命令安装make

      ```shell
      choco install make
      ```

    - 渠道3，安装mingw

      下载路径：https://sourceforge.net/projects/mingw

      里面有mingw32-make.exe，拷贝之后重命名为make.exe添加到环境变量PATH

### 使用

在你的博客工程下新建一个`Makefile`的文件，为其添加以下内容：

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

随后的效果就是，你在完成了博客编写的前两步，保存好你的博客。

在控制台输入`make`

你会发现你的整个工程被push到托管仓库，并且本地新写的文章被生成好hexo工程，启动了本地预览。浏览器也自动跳出来博客的最新版本，你简单检查一下觉得满意。

在控制台输入`make live`

你会发现你的整个工程被push到托管仓库，并且本地新写的文章被生成好hexo工程，博客也发布到github page上。



## 写在后面

其实稍微看一下Makefile文件里的内容，发现也蛮好理解的，就算没有学过。如果需要修改，注意以下的细节：

1. 上面的代码`make`等价于`make test`，原因是最后一行的`.DEFAULT_GOAL:= test`，可以省略参数。
2. `@open -a "/Applications/Safari.app" 'http://localhost:$(PORT)' &`是macos适用的，默认打开Safari浏览器进行预览，Windows需自行探索，或去掉这一行。

引用廖雪峰大佬的博客内容：https://liaoxuefeng.com/books/makefile/introduction/index.html

> `Makefile`相当于Java项目的`pom.xml`，Node工程的`package.json`，Rust项目的`Cargo.toml`，不同之处在于，`make`虽然最初是针对C语言开发，但它实际上并不限定C语言，而是可以应用到任意项目，甚至不是编程语言。此外，`make`主要用于Unix/Linux环境的自动化开发，掌握`Makefile`的写法，可以更好地在Linux环境下做开发，也可以为后续开发Linux内核做好准备。

