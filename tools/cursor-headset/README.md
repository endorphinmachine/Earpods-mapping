# Cursor 耳机媒体键映射（AutoHotkey v2）

**仅 Cursor 前台时拦截**；其它应用里音量/播放键照常。

## 键位（简单版）

| 耳机手势 | Cursor 动作 | 按键 |
|---------|------------|------|
| 音量+ **短按** | 接受更改 | `Ctrl+Enter` |
| 音量+ **按住** / 松开 | 语音开 / 关 | `Ctrl+Shift+Space` |
| 播放/暂停 | 发送给 Agent | `Enter` |
| 音量减 | 停止生成 | `Ctrl+Shift+Backspace` |

阈值：`HoldMs := 400`（按住超过此时长才进语音，否则算短按「接受」）。

## 使用

1. 安装 [AutoHotkey v2](https://www.autohotkey.com/)
2. 托盘退出旧脚本后，双击 `cursor-headset.ahk`
3. 可选开机自启：`install-autostart.ps1`

## 说明

- 发送用**播放键**，停止用**音量减**，互不抢键。
- 若按住音量+时麦不收音，多半是 Windows 蓝牙 Hands-Free 配置问题（设置 → 声音 → 输入选免提麦）。
- 探针：`probe-keys.ahk`（只记录、不抢键）。
