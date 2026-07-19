# Earpods-mapping

苹果无线耳机 → Cursor Agent 快捷操作（Windows + AutoHotkey v2）。

脚本：[`tools/cursor-headset/`](tools/cursor-headset/)

## 键位

| 耳机 | 动作 |
|------|------|
| 音量+ 短按 | 接受更改 |
| 音量+ 按住 | 语音输入（松开结束） |
| 播放/暂停 | 发送 |
| 音量减 | 停止生成 |

```powershell
# 运行
& "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe" ".\tools\cursor-headset\cursor-headset.ahk"

# 开机自启（可选）
powershell -ExecutionPolicy Bypass -File tools\cursor-headset\install-autostart.ps1
```

详情见 [`tools/cursor-headset/README.md`](tools/cursor-headset/README.md)。
