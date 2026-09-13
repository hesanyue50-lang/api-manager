#!/bin/sh
# 自动同步脚本：AIWord 源码 → 沙盒仓库 → GitHub
# 用法：sh sync.sh [提交信息]

set -e

# 路径配置
SRC="/var/minis/mounts/AIWord/projects/balance-widget"
REPO="/var/minis/shared/api-manager"

# 检查源码目录
if [ ! -d "$SRC" ]; then
  echo "❌ 源码目录不存在: $SRC"
  exit 1
fi

cd "$REPO"

# 同步源码（排除编译产物）
echo "📦 同步源码..."
tar --exclude='./build' \
    --exclude='./*.apk' \
    --exclude='./*.idsig' \
    --exclude='./.git' \
    --exclude='./tools/probe.jar' \
    -cf - -C "$SRC" . | tar -xf -

# 检查是否有变更
if git diff --quiet && git diff --cached --quiet; then
  echo "✅ 无变更，跳过提交"
  exit 0
fi

# 提交
MSG="${1:-自动同步 $(date '+%Y-%m-%d %H:%M')}"
git add -A
git commit -m "$MSG"

# 推送
echo "🚀 推送到 GitHub..."
git push

echo "✅ 同步完成: $MSG"
