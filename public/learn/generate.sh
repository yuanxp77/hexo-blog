#!/bin/sh

HTML_FILE="index.html"
TITLE="学习资源管理"

# 创建HTML文件头部
cat > $HTML_FILE <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>$TITLE</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 20px; 
            background-color: #f8f9fa;
            line-height: 1.6;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 { 
            color: #2c3e50; 
            border-bottom: 3px solid #3498db; 
            padding-bottom: 15px; 
            margin-bottom: 30px;
            font-size: 2.5em;
            text-align: center;
        }
        .update-time {
            text-align: center;
            color: #7f8c8d;
            font-style: italic;
            margin-bottom: 30px;
        }
        .section {
            margin-bottom: 40px;
        }
        .section-title {
            color: #34495e;
            font-size: 1.5em;
            margin-bottom: 20px;
            padding: 10px 0;
            border-bottom: 2px solid #ecf0f1;
        }
        ul { 
            list-style-type: none; 
            padding: 0; 
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
        }
        li { 
            margin: 0; 
            padding: 15px; 
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #3498db;
            transition: all 0.3s ease;
        }
        li:hover {
            background: #e3f2fd;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        a { 
            color: #2980b9; 
            text-decoration: none; 
            font-weight: 500;
            display: block;
        }
        a:hover { 
            color: #1abc9c;
            text-decoration: underline; 
        }
        .file-item { 
            display: flex; 
            align-items: center; 
        }
        .file-icon { 
            margin-right: 12px; 
            font-size: 1.2em;
        }
        .dir { 
            color: #e74c3c; 
            font-weight: bold; 
        }
        .html-file {
            color: #27ae60;
        }
        .other-file {
            color: #8e44ad;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        .empty-state .icon {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
        }
        .stats {
            background: #ecf0f1;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: center;
        }
        .stats span {
            display: inline-block;
            margin: 0 20px;
            color: #2c3e50;
            font-weight: 500;
        }
        .refresh-note {
            background: #d5dbdb;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 0.9em;
            color: #2c3e50;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 学习资源管理中心</h1>
        <p class="update-time">更新时间: $(date '+%Y-%m-%d %H:%M:%S')</p>
        
        <div class="refresh-note">
            💡 提示: 运行 <code>./generate.sh</code> 可以重新生成此页面
        </div>
EOF

# 统计文件和文件夹数量
folder_count=0
html_count=0
other_count=0

# 先统计数量
for item in *; do
    if [ "$item" != "$HTML_FILE" ] && [ "$item" != "generate.sh" ]; then
        if [ -d "$item" ]; then
            folder_count=$((folder_count + 1))
        elif [ -f "$item" ]; then
            case "$item" in
                *.html|*.htm)
                    html_count=$((html_count + 1))
                    ;;
                *)
                    other_count=$((other_count + 1))
                    ;;
            esac
        fi
    fi
done

total_count=$((folder_count + html_count + other_count))

# 添加统计信息
cat >> $HTML_FILE <<EOF
        <div class="stats">
            <span>📁 文件夹: <strong>$folder_count</strong></span>
            <span>📄 HTML文件: <strong>$html_count</strong></span>
            <span>📋 其他文件: <strong>$other_count</strong></span>
            <span>📊 总资源: <strong>$total_count</strong></span>
        </div>
EOF

# 检查是否有内容
if [ $total_count -eq 0 ]; then
    cat >> $HTML_FILE <<EOF
        <div class="empty-state">
            <span class="icon">📚</span>
            <h3>暂无学习资源</h3>
            <p>
                请在 learn 文件夹下创建子文件夹或添加学习文件。<br>
                创建后运行 <code>./generate.sh</code> 重新生成此页面。
            </p>
        </div>
EOF
else
    # 添加文件夹部分
    if [ $folder_count -gt 0 ]; then
        cat >> $HTML_FILE <<EOF
        <div class="section">
            <h2 class="section-title">📁 学习分类</h2>
            <ul>
EOF
        
        # 遍历文件夹
        for item in *; do
            if [ "$item" != "$HTML_FILE" ] && [ "$item" != "generate.sh" ] && [ -d "$item" ]; then
                echo "                <li class=\"file-item\">" >> $HTML_FILE
                echo "                    <span class=\"file-icon\">📁</span>" >> $HTML_FILE
                echo "                    <div>" >> $HTML_FILE
                echo "                        <a href=\"$item/\" class=\"dir\">$item</a>" >> $HTML_FILE
                echo "                        <small style=\"color: #7f8c8d; display: block; margin-top: 5px;\">学习资源分类目录</small>" >> $HTML_FILE
                echo "                    </div>" >> $HTML_FILE
                echo "                </li>" >> $HTML_FILE
            fi
        done
        
        cat >> $HTML_FILE <<EOF
            </ul>
        </div>
EOF
    fi
    
    # 添加HTML文件部分
    if [ $html_count -gt 0 ]; then
        cat >> $HTML_FILE <<EOF
        <div class="section">
            <h2 class="section-title">📄 学习文档</h2>
            <ul>
EOF
        
        # 遍历HTML文件
        for item in *; do
            if [ "$item" != "$HTML_FILE" ] && [ "$item" != "generate.sh" ] && [ -f "$item" ]; then
                case "$item" in
                    *.html|*.htm)
                        # 获取文件修改时间
                        file_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$item" 2>/dev/null || date -r "$item" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "未知时间")
                        echo "                <li class=\"file-item\">" >> $HTML_FILE
                        echo "                    <span class=\"file-icon\">📄</span>" >> $HTML_FILE
                        echo "                    <div>" >> $HTML_FILE
                        echo "                        <a href=\"$item\" class=\"html-file\">$item</a>" >> $HTML_FILE
                        echo "                        <small style=\"color: #7f8c8d; display: block; margin-top: 5px;\">修改时间: $file_time</small>" >> $HTML_FILE
                        echo "                    </div>" >> $HTML_FILE
                        echo "                </li>" >> $HTML_FILE
                        ;;
                esac
            fi
        done
        
        cat >> $HTML_FILE <<EOF
            </ul>
        </div>
EOF
    fi
    
    # 添加其他文件部分
    if [ $other_count -gt 0 ]; then
        cat >> $HTML_FILE <<EOF
        <div class="section">
            <h2 class="section-title">📋 其他资源</h2>
            <ul>
EOF
        
        # 遍历其他文件
        for item in *; do
            if [ "$item" != "$HTML_FILE" ] && [ "$item" != "generate.sh" ] && [ -f "$item" ]; then
                case "$item" in
                    *.html|*.htm)
                        # 跳过HTML文件，已在上面处理
                        ;;
                    *)
                        # 获取文件大小和修改时间
                        file_size=$(ls -lh "$item" | awk '{print $5}' 2>/dev/null || echo "未知大小")
                        file_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$item" 2>/dev/null || date -r "$item" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "未知时间")
                        
                        # 根据文件扩展名选择图标
                        case "$item" in
                            *.pdf) icon="📕" ;;
                            *.doc|*.docx) icon="📘" ;;
                            *.ppt|*.pptx) icon="📙" ;;
                            *.xls|*.xlsx) icon="📗" ;;
                            *.txt|*.md) icon="📝" ;;
                            *.zip|*.rar|*.7z) icon="📦" ;;
                            *.jpg|*.jpeg|*.png|*.gif) icon="🖼️" ;;
                            *.mp4|*.avi|*.mov) icon="🎬" ;;
                            *.mp3|*.wav|*.flac) icon="🎵" ;;
                            *) icon="📄" ;;
                        esac
                        
                        echo "                <li class=\"file-item\">" >> $HTML_FILE
                        echo "                    <span class=\"file-icon\">$icon</span>" >> $HTML_FILE
                        echo "                    <div>" >> $HTML_FILE
                        echo "                        <a href=\"$item\" class=\"other-file\">$item</a>" >> $HTML_FILE
                        echo "                        <small style=\"color: #7f8c8d; display: block; margin-top: 5px;\">大小: $file_size | 修改时间: $file_time</small>" >> $HTML_FILE
                        echo "                    </div>" >> $HTML_FILE
                        echo "                </li>" >> $HTML_FILE
                        ;;
                esac
            fi
        done
        
        cat >> $HTML_FILE <<EOF
            </ul>
        </div>
EOF
    fi
fi

# 添加HTML尾部
cat >> $HTML_FILE <<EOF
    </div>

    <script>
        // 添加一些交互功能
        document.addEventListener('DOMContentLoaded', function() {
            // 为链接添加点击统计（可选）
            const links = document.querySelectorAll('a[href]');
            links.forEach(link => {
                link.addEventListener('click', function() {
                    console.log('访问资源:', this.textContent, '路径:', this.href);
                });
            });
            
            // 添加键盘快捷键支持
            document.addEventListener('keydown', function(e) {
                // Ctrl/Cmd + R 刷新页面
                if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
                    location.reload();
                }
            });
        });
    </script>
</body>
</html>
EOF

echo "✅ 学习资源索引页面已生成: $HTML_FILE"
echo "📊 统计信息:"
echo "   📁 文件夹: $folder_count 个"
echo "   📄 HTML文件: $html_count 个" 
echo "   📋 其他文件: $other_count 个"
echo "   📊 总资源: $total_count 个"
echo ""
echo "💡 提示: 添加新的学习资源后，请重新运行此脚本更新索引页面"

# 可选：自动打开生成的页面（取消注释下面的行）
# xdg-open $HTML_FILE 2>/dev/null || open $HTML_FILE 2>/dev/null
