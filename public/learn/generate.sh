#!/bin/sh

HTML_FILE="index.html"

# 创建HTML文件头部
cat > $HTML_FILE <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>学习资源</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #2c3e50; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        ul { list-style-type: none; padding: 0; }
        li { margin: 8px 0; padding: 5px; }
        a { color: #3498db; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .file-item { display: flex; align-items: center; }
        .file-icon { margin-right: 10px; }
        .dir { color: #e74c3c; font-weight: bold; }
    </style>
</head>
<body>
    <h1>学习资源</h1>
    <p>update time: $(date '+%Y-%m-%d %H:%M:%S')</p>
    <ul>
EOF

# 遍历当前目录
for item in *; do
    if [ "$item" != "$HTML_FILE" ] && [ "$item" != "generate.sh" ]; then
        if [ -d "$item" ]; then
            # 目录项
            echo "        <li class=\"file-item\">📁 <a href=\"$item/\" class=\"dir\">$item/</a></li>" >> $HTML_FILE
        else
            # 文件项
            echo "        <li class=\"file-item\">📄 <a href=\"$item\">$item</a></li>" >> $HTML_FILE
        fi
    fi
done

# 添加HTML尾部
cat >> $HTML_FILE <<EOF
    </ul>
</body>
</html>
EOF

echo "学习资源索引页面已生成: $HTML_FILE"