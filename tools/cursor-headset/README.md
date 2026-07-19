# Cursor 耳机媒体键映射（AutoHotkey v2）

将苹果无线耳机（AirPods / Beats 等）的媒体键映射为 Cursor Agent 常用操作。**仅当 Cursor 前台时拦截**；Cursor 未激活时媒体键照常交给系统（音乐、系统音量等）。

## 键位表（当前生效）

| 耳机手势 | Cursor 动作 | 发送按键（Windows） |
|---------|------------|-------------------|
| 播放/暂停（单击） | 开/关 Cursor 语音 | `F13` → `composer.toggleVoiceDictation` |
| 音量加 | 接受全部更改 | `Ctrl+Enter` |
| 音量减 | 停止生成 | `Ctrl+Shift+Backspace` |

**无长按映射**。发送请用键盘 `Enter`。停止用 **音量减**。

### 为什么不用 Ctrl+Shift+Space？

AHK 模拟 `Ctrl+Shift+Space` 时经常**只生效一次**（修饰键残留 / 蓝牙通话档后合成按键失效），但 ToolTip 仍会显示。改为发送无修饰键的 **F13**，并在 Cursor 里绑定：

`F13` → `composer.toggleVoiceDictation`（Toggle Voice Mode）

一键安装绑定：

```powershell
powershell -ExecutionPolicy Bypass -File .\install-voice-keybinding.ps1
```

或手动：`Ctrl+K Ctrl+S` → 搜 `Toggle Voice Mode` → 设为 `F13`。

脚本顶部常量：

- `ShowTips := true`
- `VoiceKey := "{F13}"` — 须与 Cursor 快捷键一致
- `DebounceMs := 600` — 防止连按

**若音量加减突然全失效：** 退出旧版会吞键的 `probe-keys.ahk`，只保留 `cursor-headset.ahk`。

### 麦克风失效时（Windows + 苹果耳机）

线控正常但没声音进 Cursor，几乎都是蓝牙音频配置问题，不是 AHK 映射坏了：

1. 先确认脚本里 `EnableVoice := false`，退出旧脚本后重新运行 `cursor-headset.ahk`（避免误触语音）。
2. 设置 → 系统 → 声音 → **输入**：选带 **Hands-Free AG Audio / 免提** 字样的耳机麦；不要选只有 Stereo 的输出设备当输入（Stereo 没有麦克风通道）。
3. 经典声音面板（`mmsys.cpl`）→ 录制：把 Hands-Free 设为默认设备/默认通讯设备。
4. Cursor 语音/系统隐私里允许麦克风；输入设备也选 Hands-Free。
5. 仍不行：蓝牙里移除耳机 → 耳机入盒长按复位 → 重新配对。

麦克风稳定后，若仍要用长按语音：把 `EnableVoice := true` 保存并重启脚本。

作用域：`#HotIf WinActive("ahk_exe Cursor.exe")`。

## 安装 AutoHotkey v2

1. 打开 [AutoHotkey 官网](https://www.autohotkey.com/) 下载 **v2**（不要用 v1）。
2. 安装时勾选当前用户或系统均可；本脚本不需要管理员权限。

## 如何运行

1. （可选）先跑探针，确认耳机按键能到达 Windows：
   - 双击 `probe-keys.ahk`
   - 按耳机音量加减、播放/暂停（短按/长按/双击），看屏幕 ToolTip，或同目录 `probe-keys.log`
   - 若双击出现 `Media_Next` / `Media_Prev` 而不是两次 Play/Pause，把日志发回来，可改映射到「停止生成」
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
4. 若长按始终无事件：语音改用键盘 `Ctrl+M` / `Ctrl+Shift+Space`，或把能到达的键（如音量组合）自行改绑。

## 行为摘要

- **Cursor 前台**：音量加减与播放/暂停被脚本消费并映射为上表快捷键。
- **非 Cursor**：`#HotIf` 不生效，系统正常处理媒体键。
- 长按触发语音后，松开只结束语音，**不会**再发 Enter。
- **停止生成**仅绑定音量减（双击手势已弃用）。
