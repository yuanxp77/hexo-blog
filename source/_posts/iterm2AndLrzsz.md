---
title: Mac M1 + iterm2 使用 lrzsz
date: 2025-10-24 12:01:18
tags:
---

> 转载个人自用，方便使用，转载自：https://www.cnblogs.com/elve960520/p/18685205

亲测好用

step1:
在服务器安装 lrzsz 官网
这个跟官网走就行,没啥要求

step2:
本地安装 lrzsz
brew install lrzsz

step3:
新建两个文件,拷贝下面代码并赋运行权限
/usr/local/bin/iterm2-recv-zmodem.sh

```shell
#!/bin/bash
# Author: Matt Mastracci (matthew@mastracci.com)
# AppleScript from http://stackoverflow.com/questions/4309087/cancel-button-on-osascript-in-a-bash-script
# licensed under cc-wiki with attribution required
# Remainder of script public domain

osascript -e 'tell application "iTerm2" to version' > /dev/null 2>&1 && NAME=iTerm2 || NAME=iTerm
if [[ $NAME = "iTerm" ]]; then
	FILE=$(osascript -e 'tell application "iTerm" to activate' -e 'tell application "iTerm" to set thefile to choose folder with prompt "Choose a folder to place received files in"' -e "do shell script (\"echo \"&(quoted form of POSIX path of thefile as Unicode text)&\"\")")
else
	FILE=$(osascript -e 'tell application "iTerm2" to activate' -e 'tell application "iTerm2" to set thefile to choose folder with prompt "Choose a folder to place received files in"' -e "do shell script (\"echo \"&(quoted form of POSIX path of thefile as Unicode text)&\"\")")
fi

if [[ $FILE = "" ]]; then
	echo Cancelled.
	# Send ZModem cancel
	echo -e \\x18\\x18\\x18\\x18\\x18
	sleep 1
	echo
	echo \# Cancelled transfer
else
	cd "$FILE"
	/opt/homebrew/bin/rz --rename --escape --binary --bufsize 4096
	sleep 1
	echo
	echo
	echo \# Sent \-\> $FILE
fi
```

/usr/local/bin/iterm2-send-zmodem.sh
```shell
#!/bin/bash
# Author: Matt Mastracci (matthew@mastracci.com)
# AppleScript from http://stackoverflow.com/questions/4309087/cancel-button-on-osascript-in-a-bash-script
# licensed under cc-wiki with attribution required
# Remainder of script public domain

osascript -e 'tell application "iTerm2" to version' > /dev/null 2>&1 && NAME=iTerm2 || NAME=iTerm
if [[ $NAME = "iTerm" ]]; then
	FILE=$(osascript -e 'tell application "iTerm" to activate' -e 'tell application "iTerm" to set thefile to choose file with prompt "Choose a file to send"' -e "do shell script (\"echo \"&(quoted form of POSIX path of thefile as Unicode text)&\"\")")
else
	FILE=$(osascript -e 'tell application "iTerm2" to activate' -e 'tell application "iTerm2" to set thefile to choose file with prompt "Choose a file to send"' -e "do shell script (\"echo \"&(quoted form of POSIX path of thefile as Unicode text)&\"\")")
fi
if [[ $FILE = "" ]]; then
	echo Cancelled.
	# Send ZModem cancel
	echo -e \\x18\\x18\\x18\\x18\\x18
	sleep 1
	echo
	echo \# Cancelled transfer
else
	/opt/homebrew/bin/sz "$FILE" --escape --binary --bufsize 4096
	sleep 1
	echo
	echo \# Received "$FILE"
fi
```

```shell
sudo chmod 777 /usr/local/bin/iterm2-*
```

ste4:
配置 iterm2

![alt text](image1.png)

![alt text](image2.png)

![alt text](image3.png)

规则为
```shell
rz waiting to receive.\*\*B0100
\*\*B00000000000000
```
选择两个文件即可

然后就可以测试了
在服务器运行
```shell
rz 

sz file
\*\*B