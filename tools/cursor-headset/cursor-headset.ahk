#Requires AutoHotkey v2.0
#SingleInstance Force
; Apple wireless headset → Cursor Agent media keys (Cursor foreground only).
; Outside Cursor, media keys pass through to the OS (#HotIf).
;
; Play/Pause click = toggle Cursor voice only (no long-press mapping).

ShowTips := true

Tip(msg) {
    global ShowTips
    if (!ShowTips)
        return
    ToolTip(msg)
    SetTimer(() => ToolTip(), -900)
}

IsCursorFront() {
    try {
        return (WinGetProcessName("A") = "Cursor.exe")
    } catch {
        return false
    }
}

ReleaseModifiers() {
    SendInput("{Ctrl up}{Shift up}{Alt up}")
}

ToggleVoice() {
    ; Refocus Cursor, send Trigger Voice Mode, then clear stuck modifiers
    ; so the shortcut keeps working on the next click.
    try WinActivate("ahk_exe Cursor.exe")
    Sleep(40)
    ReleaseModifiers()
    SendInput("{Ctrl down}{Shift down}{Space}{Shift up}{Ctrl up}")
    Sleep(40)
    ReleaseModifiers()
    Tip("语音 开/关")
}

A_IconTip := "Cursor Headset — click Play=voice  Vol+/-=accept/stop"
TrayTip("Cursor 耳机映射已启动", "短按播放=语音开关`n音量+=接受  音量-=停止`n（无长按映射）", "Iconi")

#HotIf IsCursorFront()

$Volume_Up:: {
    SendInput("^{Enter}")
    Tip("接受更改")
}

$Volume_Down:: {
    SendInput("^+{Backspace}")
    Tip("停止生成")
}

; Click Play/Pause → toggle voice only (ignore hold duration).
$*Media_Play_Pause:: {
    ; Swallow key-down; act on key-up to avoid repeat fire while held.
}

$*Media_Play_Pause Up:: {
    ToggleVoice()
}

#HotIf
