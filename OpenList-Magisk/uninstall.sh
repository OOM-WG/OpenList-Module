# shellcheck shell=ash
# uninstall.sh for OpenList Magisk Module

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 停止服务函数
stop_service() {
    if pgrep -f openlist >/dev/null; then
        log "正在停止 OpenList 服务..."
        pkill -f openlist
        sleep 1
        if pgrep -f openlist >/dev/null; then
            log "警告：无法完全停止 OpenList 服务"
            return 1
        else
            log "OpenList 服务已停止"
            return 0
        fi
    else
        log "OpenList 服务未运行"
        return 0
    fi
}

# 清理二进制文件
clean_binaries() {
    local found=0
    local path="/data/adb/openlist/bin/openlist"
    if [ -f "$path" ]; then
        log "正在删除二进制文件：$path"
        rm -f "$path"
        found=1
    fi
    
    if [ $found -eq 0 ]; then
        log "未找到 OpenList 二进制文件"
    fi
}

# 主要卸载流程
main() {
    log "开始卸载 OpenList Magisk 模块..."

    # 停止服务
    stop_service
    
    # 清理二进制文件
    clean_binaries
    
    log "卸载完成"
    echo "请重启设备以完成卸载"
}

# 执行主函数
main