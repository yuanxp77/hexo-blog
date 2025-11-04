#!/bin/sh

HTML_FILE="index.html"

# 函数：为指定目录生成index.html
generate_index() {
    local dir="$1"
    local title="$2"
    local back_link="$3"
    
    cd "$dir"
    
    # 创建HTML文件头部
    cat > $HTML_FILE <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>$title</title>
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
        .back-link { margin-bottom: 20px; }
        .back-link a { color: #95a5a6; }
    </style>
</head>
<body>
EOF

    # 如果有返回链接，添加返回链接
    if [ -n "$back_link" ]; then
        cat >> $HTML_FILE <<EOF
    <div class="back-link">
        <a href="$back_link">← 返回学习资源</a>
    </div>
EOF
    fi

    # 添加标题和更新时间
    cat >> $HTML_FILE <<EOF
    <h1>$title</h1>
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

    echo "已生成: $dir/$HTML_FILE"
}

# 主脚本开始
SCRIPT_DIR=$(pwd)

# 生成主目录的index.html
generate_index "$SCRIPT_DIR" "学习资源" ""

# 遍历所有子目录，为每个子目录生成index.html
for subdir in */; do
    if [ -d "$subdir" ]; then
        # 去掉末尾的斜杠
        dirname=$(echo "$subdir" | sed 's/\/$//')
        
        # 为子目录生成index.html
        generate_index "$SCRIPT_DIR/$dirname" "$dirname" "../"
        
        # 返回主目录
        cd "$SCRIPT_DIR"
    fi
done

echo "所有学习资源索引页面已生成完成！"