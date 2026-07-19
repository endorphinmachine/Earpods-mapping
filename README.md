# Earpods-mapping

将苹果无线耳机媒体键映射到 Cursor Agent 常用操作（**仅 Cursor 前台时生效**；否则媒体键交给系统）。

实现：Windows + **AutoHotkey v2**，脚本与说明在 [`tools/cursor-headset/`](tools/cursor-headset/)。

## 键位摘要

| 耳机操作 | Cursor 动作 | 发送按键 |
|---------|------------|---------|
| 短按 播放/暂停 | 发送给 Agent | `Enter` |
| 长按 播放/暂停（按住 / 松开） | 开始 / 结束语音 | `Ctrl+M` 按下/抬起（PTT）；或 `Ctrl+Shift+Space` 切换 |
| 双击 播放/暂停 | 停止生成 | `Ctrl+Shift+Backspace` |
| 音量加 | 接受全部更改 | `Ctrl+Enter` |
| 音量减 | 停止生成 | `Ctrl+Shift+Backspace` |

## 快速使用

1. 安装 [AutoHotkey v2](https://www.autohotkey.com/)
2. 可选：运行 `tools/cursor-headset/probe-keys.ahk` 确认按键能到达 Windows
3. 双击 `tools/cursor-headset/cursor-headset.ahk` 启动
4. 开机自启（当前用户，无需管理员）：

```powershell
powershell -ExecutionPolicy Bypass -File tools\cursor-headset\install-autostart.ps1
```

完整说明、阈值、语音模式切换与长按固件限制见 [`tools/cursor-headset/README.md`](tools/cursor-headset/README.md)。
