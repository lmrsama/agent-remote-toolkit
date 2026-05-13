#!/usr/bin/env bash
# claw-remote-takeover skill installer
# 用法：curl -fsSL https://raw.githubusercontent.com/lmrsama/agent-remote-toolkit/main/install.sh | bash

set -e

SKILL_NAME="claw-remote-takeover"
TARGET_DIR="$HOME/.workbuddy/skills/$SKILL_NAME"
SOURCE_URL="https://raw.githubusercontent.com/lmrsama/agent-remote-toolkit/main/skills/$SKILL_NAME/SKILL.md"

echo "==> 安装 claw-remote-takeover skill"
echo "    目标目录：$TARGET_DIR"

# 1. 检查 ~/.workbuddy/skills 是否存在
if [ ! -d "$HOME/.workbuddy/skills" ]; then
    echo "    创建 ~/.workbuddy/skills/"
    mkdir -p "$HOME/.workbuddy/skills"
fi

# 2. 已存在则备份旧版
if [ -d "$TARGET_DIR" ]; then
    BACKUP="${TARGET_DIR}.bak.$(date +%Y%m%d-%H%M%S)"
    echo "    检测到已安装，备份旧版到：$BACKUP"
    mv "$TARGET_DIR" "$BACKUP"
fi

# 3. 创建目录并下载 SKILL.md
mkdir -p "$TARGET_DIR"
echo "    下载 SKILL.md..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$SOURCE_URL" -o "$TARGET_DIR/SKILL.md"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$SOURCE_URL" -O "$TARGET_DIR/SKILL.md"
else
    echo "    [错误] 找不到 curl 或 wget，请手动下载"
    echo "    手动下载地址：$SOURCE_URL"
    exit 1
fi

# 4. 验证
if [ ! -s "$TARGET_DIR/SKILL.md" ]; then
    echo "    [错误] 下载失败，SKILL.md 为空"
    exit 1
fi

echo ""
echo "✅ 安装成功"
echo ""
echo "下一步："
echo "  1. 打开 CodeBuddy（重启一次让它扫到新 skill）"
echo "  2. 进入你想远程化的项目目录"
echo "  3. 在对话框里发：/skill claw-remote-takeover"
echo ""
echo "完整文档：https://lmrsama.github.io/agent-remote-toolkit/"
