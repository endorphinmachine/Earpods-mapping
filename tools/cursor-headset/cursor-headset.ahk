#Requires AutoHotkey v2.0
#SingleInstance Force
; Cursor foreground only:
;   Vol+ hold   → Voice (down=start, up=stop)
;   Play/Pause  → Ctrl+Enter (send)
;   Vol-        → Stop generation

ShowTips := true
voiceOn := false

Tip(msg) {
    global ShowTips
    if !ShowTips
        return
    ToolTip(msg)
    SetTimer(() => ToolTip(), -800)
}

IsCursorFront() {
    try
        return WinGetProcessName("A") = "Cursor.exe"
    catch
        return false
}

ReleaseModifiers() {
    SendInput("{Ctrl up}{Shift up}{Alt up}")
}

StartVoice() {
    global voiceOn
    if voiceOn
        return
    ReleaseModifiers()
    SendEvent("{Ctrl down}{Shift down}{Space}{Shift up}{Ctrl up}")
    ReleaseModifiers()
    voiceOn := true
    Tip("语音：开")
}

StopVoice() {
    global voiceOn
    if !voiceOn
        return
    ReleaseModifiers()
    SendEvent("{Ctrl down}{Shift down}{Space}{Shift up}{Ctrl up}")
    ReleaseModifiers()
    voiceOn := false
    Tip("语音：关")
}

A_IconTip := "Cursor Headset: Vol+=voice | Play=Ctrl+Enter | Vol-=stop"
TrayTip("Cursor 耳机映射", "音量+=语音(按住)`n播放=Ctrl+Enter发送`n音量-=停止", "Iconi")

#HotIf IsCursorFront()

; Volume Up: voice only (press=start, release=stop)
$*Volume_Up:: {
    StartVoice()
}

$*Volume_Up Up:: {
    StopVoice()
}

; Volume Down: stop generation
$Volume_Down:: {
    SendInput("^+{Backspace}")
    Tip("停止生成")
}

; Play/Pause: Ctrl+Enter send
$Media_Play_Pause:: {
    SendInput("^{Enter}")
    Tip("发送 Ctrl+Enter")
}

#HotIf
