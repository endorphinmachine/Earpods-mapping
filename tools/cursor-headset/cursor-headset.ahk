#Requires AutoHotkey v2.0
#SingleInstance Force
; Apple wireless headset → Cursor Agent media keys (Cursor foreground only).
;
; Play/Pause click sends F13 (not Ctrl+Shift+Space). Bind in Cursor:
;   F13 → composer.toggleVoiceDictation
; See cursor-keybindings.fragment.json / README.
; Ctrl+Shift+Space often works only once when sent via AHK (stuck modifiers /
; Cursor voice state). F13 is a single key with no modifiers.

ShowTips := true
DebounceMs := 600
VoiceKey := "{F13}"          ; must match Cursor keybinding
lastVoiceTick := 0

Tip(msg) {
    global ShowTips
    if (!ShowTips)
        return
    ToolTip(msg)
    SetTimer(() => ToolTip(), -1000)
}

IsCursorFront() {
    try {
        return (WinGetProcessName("A") = "Cursor.exe")
    } catch {
        return false
    }
}

ReleaseModifiers() {
    SendInput("{Ctrl up}{Shift up}{Alt up}{LWin up}{RWin up}")
}

ToggleVoice() {
    global VoiceKey, DebounceMs, lastVoiceTick

    now := A_TickCount
    if (now - lastVoiceTick < DebounceMs) {
        Tip("忽略连按")
        return
    }
    lastVoiceTick := now

    if !WinExist("ahk_exe Cursor.exe") {
        Tip("未找到 Cursor")
        return
    }

    try WinActivate("ahk_exe Cursor.exe")
    if !WinWaitActive("ahk_exe Cursor.exe", , 1) {
        Tip("无法激活 Cursor")
        return
    }
    Sleep(80)

    ; Clear any stuck modifiers from previous sends / headset HID.
    ReleaseModifiers()
    Sleep(30)

    ; SendEvent is more reliable than SendInput for app hotkeys after BT audio switches.
    SendEvent(VoiceKey)
    Sleep(40)
    ReleaseModifiers()

    Tip("语音切换 (F13)")
}

A_IconTip := "Cursor Headset — Play=F13 voice  Vol+/-=accept/stop"
TrayTip(
    "Cursor 耳机映射已启动",
    "播放键 → F13 语音开关`n请确认 Cursor 已绑定 F13=Toggle Voice Mode`n音量+=接受  音量-=停止",
    "Iconi"
)

#HotIf IsCursorFront()

$Volume_Up:: {
    SendInput("^{Enter}")
    Tip("接受更改")
}

$Volume_Down:: {
    SendInput("^+{Backspace}")
    Tip("停止生成")
}

$*Media_Play_Pause:: {
    ; Swallow down; handle on up (avoid key-repeat).
}

$*Media_Play_Pause Up:: {
    ToggleVoice()
}

#HotIf
