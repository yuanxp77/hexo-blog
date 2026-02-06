#!/bin/bash

# ================================
# 网易云音乐无损下载工具 - 配置区
# ================================

# 在这里配置你的歌单（可以添加多个）
PLAYLISTS=(
    "https://music.163.com/#/playlist?id=17734270320"   # for download
    # "http://music.163.com/#/playlist?id=你的歌单ID"    # 添加更多歌单
)

# 是否下载MP3格式（true=下载所有格式, false=仅下载无损FLAC）
DOWNLOAD_MP3=false

# ================================
# 以下为脚本逻辑，一般无需修改
# ================================

echo "=================================="
echo "  网易云音乐无损下载工具"
echo "=================================="
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查Python3是否安装
if ! command -v python3 &> /dev/null; then
    echo "❌ 错误: 未找到 python3，请先安装 Python 3"
    exit 1
fi

# 设置Python命令（优先使用虚拟环境）
if [ -f "$SCRIPT_DIR/venv/bin/python3" ]; then
    echo "🔧 使用虚拟环境..."
    PYTHON_CMD="$SCRIPT_DIR/venv/bin/python3"
else
    PYTHON_CMD="python3"
fi

# 检查依赖是否安装
echo "📦 检查依赖..."

if ! $PYTHON_CMD -c "import requests" 2>/dev/null; then
    echo "❌ 错误: 未安装 requests 库"
    echo ""
    echo "请运行以下命令安装依赖："
    echo "  cd $SCRIPT_DIR"
    echo "  python3 -m venv venv"
    echo "  source venv/bin/activate"
    echo "  pip install requests==2.20.0 tqdm"
    exit 1
fi

if ! $PYTHON_CMD -c "import tqdm" 2>/dev/null; then
    echo "❌ 错误: 未安装 tqdm 库"
    echo ""
    echo "请运行以下命令安装依赖："
    echo "  cd $SCRIPT_DIR"
    echo "  python3 -m venv venv"
    echo "  source venv/bin/activate"
    echo "  pip install requests==2.20.0 tqdm"
    exit 1
fi

echo "✅ 依赖检查完成"
echo ""

# 检查是否配置了歌单
if [ ${#PLAYLISTS[@]} -eq 0 ]; then
    echo "❌ 错误: 未配置歌单，请编辑脚本顶部的 PLAYLISTS 数组"
    exit 1
fi

echo "🎵 找到 ${#PLAYLISTS[@]} 个歌单"
echo ""

# 逐个下载歌单
for i in "${!PLAYLISTS[@]}"; do
    url="${PLAYLISTS[$i]}"
    idx=$((i + 1))
    
    echo ""
    echo "=================================================="
    echo "开始下载第 $idx/${#PLAYLISTS[@]} 个歌单"
    echo "URL: $url"
    echo "=================================================="
    echo ""
    
    # 构建命令
    if [ "$DOWNLOAD_MP3" = true ]; then
        $PYTHON_CMD main.py "$url" --mp3
    else
        $PYTHON_CMD main.py "$url"
    fi
    
    # 检查执行结果
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ 歌单 $idx 下载完成"
    else
        echo ""
        echo "❌ 歌单 $idx 下载失败"
    fi
done

echo ""
echo "=================================================="
echo "🎉 所有歌单下载完成！"
echo "📁 文件保存在: songs_dir/ 目录下"
echo "=================================================="
