# Cursor 耳机媒体键映射（AutoHotkey v2）

将苹果无线耳机（AirPods / Beats 等）的媒体键映射为 Cursor Agent 常用操作。**仅当 Cursor 前台时拦截**；Cursor 未激活时媒体键照常交给系统（音乐、系统音量等）。

## 键位表

| 耳机手势 | Cursor 动作 | 发送按键（Windows） |
|---------|------------|-------------------|
| 短按 播放/暂停 | 发送给 Agent | `Enter` |
| 长按 播放/暂停（按住） | 开始语音 | 优先 `Ctrl+M` 按下（Agents 窗口 PTT）；备选 `Ctrl+Shift+Space` 切换 |
| 长按后松开 | 结束语音 | `Ctrl+M` 抬起；或再发一次 `Ctrl+Shift+Space` |
| 双击 播放/暂停 | 停止生成 | `Ctrl+Shift+Backspace` |
| 音量加 | 接受全部更改 | `Ctrl+Enter` |
| 音量减 | 停止生成 | `Ctrl+Shift+Backspace` |

脚本顶部常量：

- `LongPressMs := 400` — 长按阈值
- `DoubleClickMs := 300` — 双击判定窗口（短按会等此窗口后再发 Enter，避免与双击「停止」冲突）
- `VoiceMode := "ptt"` — `"ptt"` 用 Ctrl+M 按住；若无效可改为 `"toggle"`

作用域：`#HotIf WinActive("ahk_exe Cursor.exe")`。

## 安装 AutoHotkey v2

1. 打开 [AutoHotkey 官网](https://www.autohotkey.com/) 下载 **v2**（不要用 v1）。
2. 安装时勾选当前用户或系统均可；本脚本不需要管理员权限。

## 如何运行

1. （可选）先跑探针，确认耳机按键能到达 Windows：
   - 双击 `probe-keys.ahk`
   - 按耳机音量加减、播放/暂停（短按/长按），看屏幕 ToolTip，或同目录 `probe-keys.log`
2. 双击 `cursor-headset.ahk` 启动生产脚本（托盘会出现 AutoHotkey 图标）。
3. 把 Cursor 置于前台，再试耳机手势。

命令行示例（路径按本机调整）：

```powershell
& "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe" ".\cursor-headset.ahk"
```

## 开机自启（当前用户 Startup 快捷方式）

在 PowerShell 中执行（无需管理员）：

```powershell
cd path\to\tools\cursor-headset
powershell -ExecutionPolicy Bypass -File .\install-autostart.ps1
```

脚本会在「启动」文件夹创建 `Cursor Headset Mapping.lnk`，指向 `cursor-headset.ahk`。删除该快捷方式即可取消自启。

## 暂停 / 退出

- **暂停热键**：托盘图标右键 → Pause Script（或脚本内 `Suspend`）；暂停后媒体键不再被 Cursor 映射劫持。
- **退出**：托盘图标右键 → Exit。

## 若长按永远到不了 Windows（备选说明）

部分苹果耳机固件会把「长按」吃掉（例如唤起 Siri / 降噪模式切换），**根本不向 Windows 发送 `Media_Play_Pause` 长按事件**。此时：

1. 用 `probe-keys.ahk` 验证：短按有 Down/Up，长按是否只有极短 hold，或完全无第二段事件。
2. 在手机/Mac 的耳机设置里，把触控长按改为「无」或不占用系统功能（视机型而定），再重新配对到 Windows 测试。
3. Windows 上可尝试「Apple Devices」/厂商配套软件是否暴露手势重映射。
4. 若长按始终无事件：可改用短按/双击/音量键完成发送与停止；语音可改用键盘 `Ctrl+M` 或把 `VoiceMode` 设为 `"toggle"` 并依赖能到达的按键手势（需自行改脚本绑定）。

## 行为摘要

- **Cursor 前台**：音量加减与播放/暂停被脚本消费并映射为上表快捷键。
- **非 Cursor**：`#HotIf` 不生效，系统正常处理媒体键。
- 长按触发语音后，松开只结束语音，**不会**再发 Enter。
- 短按会等待双击窗口；若窗口内出现第二次按下，则发「停止生成」而不是 Enter。
