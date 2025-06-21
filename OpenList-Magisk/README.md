# OpenList Magisk 模块安装指南

本模块将 [OpenList](https://github.com/OpenListTeam/OpenList) 文件服务器集成到 Android 系统中，当前版本：v4.0.0。

## 功能
- 自动同步 OpenList 官方版本
- 支持 ARM 和 ARM64 架构
- 首次启动生成随机管理员账号和密码，保存到 `/data/adb/modules/openlist-magisk/随机密码.txt`（格式为“账号：xxx”和“密码：xxx”）
- 系统启动后自动运行 OpenList 服务，数据存储在模块的 `data` 目录（/data/adb/modules/openlist-magisk/data）
- 通过 Magisk 的“动作”按钮切换 OpenList 服务状态
- 仅在“运行中”状态下，module.prop 的 description 显示账号和密码

## 安装流程
1. **准备工作**：
   - 确保设备已安装 Magisk（建议 v28.0 或更高版本以支持动作按钮）。
   - 设备已获得 Root 权限。
   - 确保有网络连接以下载模块。

2. **下载模块**：
   - 从 [GitHub Releases](https://github.com/Alien-Et/OpenList-Magisk/releases) 下载最新模块 ZIP 文件（例如：openlist-magisk-v4.0.0.zip）。

3. **安装模块**：
   - 打开 Magisk 应用，进入“模块”选项卡。
   - 点击“从本地安装”，选择下载的 ZIP 文件。
   - 安装过程会显示：
     - 设备架构（ARM 或 ARM64）。
     - OpenList 二进制安装路径（/system/bin/openlist）。
   - 安装完成后，重启设备以启动 OpenList 服务并生成初始密码。

4. **验证安装**：
   - 检查 `/data/adb/modules/openlist-magisk/随机密码.txt` 是否存在，格式为：
     ```
     账号：xxx
     密码：xxx
     ```
   - 查看 `/data/adb/modules/openlist-magisk/module.prop`，在“运行中”状态下确认 description 包含：
     ```
     【运行中】局域网地址：http://<IP>:5244 项目地址：https://github.com/Alien-Et/OpenList-Magisk | 初始账号：xxx | 初始密码：xxx（仅未手动修改时有效）
     ```
   - 运行以下命令检查 OpenList 服务：
     ```bash
     openlist version
     ```
   - 访问 OpenList Web 界面（默认：http://localhost:5244，使用 `随机密码.txt` 中的账号和密码登录）。

## 使用说明
- **服务管理**：
  - OpenList 服务在系统启动完成后自动运行（通过 service.sh），模块描述显示：
    ```
    【运行中】局域网地址：http://<设备IP>:5244 项目地址：https://github.com/Alien-Et/OpenList-Magisk | 初始账密请移步到"/data/adb/modules/openlist-magisk/随机密码.txt"查看
    ```
  - 在 Magisk 应用中点击“动作”按钮：
    - 如果 OpenList 服务正在运行，点击停止服务，模块描述更新为：
      ```
      【已停止】请点击"操作"启动程序。项目地址：https://github.com/Alien-Et/OpenList-Magisk
      ```
    - 如果 OpenList 服务未运行，点击启动服务，模块描述恢复为“运行中”状态。
- **数据目录**：OpenList 数据存储在 `/data/adb/modules/openlist-magisk/data`，覆盖安装不会重置密码（除非手动删除 随机密码.txt）。
- **密码生成**：
  - 首次安装并重启后，自动生成随机密码，保存到 `随机密码.txt`。
  - 后续重启若 `随机密码.txt` 存在，则不修改密码；若不存在，则生成新密码。
  - 密码格式：
    ```
    账号：admin
    密码：xxxxxxxx
    ```
  - 初始账号和密码仅在“运行中”状态下显示在 module.prop 的 description 中，带备注“仅未手动修改时有效”。
- **更新模块**：通过 Magisk 检查更新，或手动下载最新 ZIP 文件重新安装。
- **卸载模块**：在 Magisk 中禁用或删除模块，重启设备（data 目录和 随机密码.txt 需手动清理）。

## 常见问题
- **Q: 无法访问 Web 界面？**
  - 确保网络正常，尝试使用设备 IP 访问（http://<设备IP>:5244）。
  - 检查服务状态：
    ```bash
    pgrep -f openlist
    ```
  - 手动启动服务：
    ```bash
    su -c /data/adb/modules/openlist-magisk/action.sh
    ```
- **Q: 密码丢失？**
  - 查看 `/data/adb/modules/openlist-magisk/随机密码.txt` 或 module.prop 的 description（“运行中”状态）。
  - 若 随机密码.txt 被删除，可重启设备重新生成密码。
- **Q: 动作按钮无法停止服务？**
  - 确保 Magisk 版本 >= v28.0。
  - 手动检查：
    ```bash
    su -c pkill -f openlist
    su -c /data/adb/modules/openlist-magisk/action.sh
    ```
- **Q: module.prop 未显示账号和密码？**
  - 确认 OpenList 服务是否运行：
    ```bash
    pgrep -f openlist
    ```
  - 检查 `随机密码.txt` 内容和格式：
    ```bash
    cat /data/adb/modules/openlist-magisk/随机密码.txt
    ```
  - 查看日志：
    ```bash
    cat /data/adb/modules/openlist-magisk/service.log
    ```
  - 手动运行 service.sh：
    ```bash
    su -c /data/adb/modules/openlist-magisk/service.sh
    ```
  - 检查 module.prop：
    ```bash
    cat /data/adb/modules/openlist-magisk/module.prop
    ```

## 更多信息
访问 [项目主页](https://github.com/Alien-Et/OpenList-Magisk) 获取完整文档和更新日志。
