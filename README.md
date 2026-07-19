# Earpods-mapping

苹果无线耳机 → Cursor Agent 快捷操作（Windows + AutoHotkey v2）。

脚本：[`tools/cursor-headset/`](tools/cursor-headset/)

## 键位

| 耳机 | 动作 |
|------|------|
| 音量+（按下/松开） | `Ctrl+M` 按住说话（Agents 窗口） |
| 播放/暂停 | 发送（`Ctrl+Enter`） |
| 音量减 | 停止生成 |

```powershell
# 运行
& "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe" ".\tools\cursor-headset\cursor-headset.ahk"

# 开机自启（可选）
powershell -ExecutionPolicy Bypass -File tools\cursor-headset\install-autostart.ps1
```

详情见 [`tools/cursor-headset/README.md`](tools/cursor-headset/README.md)。
