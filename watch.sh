#!/bin/sh
# 文件变更监听 + 自动同步
# 用法：sh watch.sh [轮询间隔秒数，默认 3]
# Ctrl+C 退出

set -e

SRC="/var/minis/mounts/AIWord/projects/balance-widget"
REPO="/var/minis/shared/api-manager"
INTERVAL="${1:-3}"
STAMP="/tmp/api-manager-stamp"
SYNCING=0

# 排除的目录/文件
EXCLUDE="--exclude=./build --exclude=./*.apk --exclude=./*.idsig --exclude=./.git --exclude=./tools/probe.jar"

log() {
  echo "[$(date '+%H:%M:%S')] $*"
}

# 获取当前文件快照（时间戳 + 大小）
snapshot() {
  find "$SRC" -type f \
    ! -path '*/build/*' \
    ! -name '*.apk' \
    ! -name '*.idsig' \
    ! -path '*/.git/*' \
    ! -name 'probe.jar' \
    -exec stat -c '%Y %s %n' {} \; 2>/dev/null | sort
}

# 检查是否有变更
check_change() {
  if [ ! -f "$STAMP" ]; then
    snapshot > "$STAMP"
    return 1
  fi
  
  local current
  current=$(snapshot)
  
  if [ "$current" != "$(cat "$STAMP")" ]; then
    echo "$current" > "$STAMP"
    return 0
  fi
  return 1
}

# 同步
do_sync() {
  if [ "$SYNCING" = "1" ]; then
    return
  fi
  SYNCING=1
  
  log "检测到变更，开始同步..."
  
  cd "$REPO"
  
  # 同步文件
  tar $EXCLUDE -cf - -C "$SRC" . | tar -xf - 2>/dev/null
  
  # 检查是否有实际变更
  if git diff --quiet && git diff --cached --quiet; then
    log "文件无实质变更"
    SYNCING=0
    return
  fi
  
  # 提交
  local msg="自动同步 $(date '+%Y-%m-%d %H:%M')"
  git add -A
  git commit -m "$msg" >/dev/null 2>&1
  
  # 推送
  if git push >/dev/null 2>&1; then
    log "✅ 已推送到 GitHub"
  else
    log "❌ 推送失败"
  fi
  
  SYNCING=0
}

# 清理
cleanup() {
  log "停止监听"
  rm -f "$STAMP"
  exit 0
}

trap cleanup INT TERM

log "开始监听 $SRC"
log "轮询间隔: ${INTERVAL}s"
log "Ctrl+C 退出"

# 初始化快照
snapshot > "$STAMP"

while true; do
  sleep "$INTERVAL"
  if check_change; then
    do_sync
  fi
done
