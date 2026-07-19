# Cursor 耳机媒体键映射（AutoHotkey v2）

**仅 Cursor 前台时拦截。**

## 键位

| 耳机 | 动作 | 按键 |
|------|------|------|
| 音量+（按下/松开） | 按住说话 / 松开结束 | `Ctrl+M` 按下 / 抬起（Agents 窗口 PTT） |
| 播放/暂停 | 发送给 Agent | `Ctrl+Enter` |
| 音量减 **短按** | 停止生成 | `Ctrl+Shift+Backspace` |
| 音量减 **长按** | 清空对话框输入 | `Ctrl+A` → `Delete` |

音量加只映射 Ctrl+M。长按阈值 `HoldMs := 400`。请在 **Agents 窗口**使用语音。

## 使用

1. 安装 AutoHotkey v2  
2. 退出旧脚本后运行 `cursor-headset.ahk`  
3. 可选：`install-autostart.ps1` 开机自启  
