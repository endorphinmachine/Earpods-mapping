#Requires AutoHotkey v2.0
#SingleInstance Force
; Simple Cursor headset map (only while Cursor.exe is foreground):
;   Vol+ short  → Accept changes
;   Vol+ hold   → Voice (start after hold, stop on release)
;   Play/Pause  → Send
;   Vol-        → Stop generation

HoldMs := 400
ShowTips := true

; vol+ state: idle | pressed | voice
volState := "idle"

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
    ReleaseModifiers()
    SendEvent("{Ctrl down}{Shift down}{Space}{Shift up}{Ctrl up}")
    ReleaseModifiers()
    Tip("语音：开")
}

StopVoice() {
    ReleaseModifiers()
    SendEvent("{Ctrl down}{Shift down}{Space}{Shift up}{Ctrl up}")
    ReleaseModifiers()
    Tip("语音：关")
}

VolHoldTimer() {
    global volState
    if (volState = "pressed") {
        volState := "voice"
        StartVoice()
    }
}

A_IconTip := "Cursor Headset: Vol+ accept/voice | Play send | Vol- stop"
TrayTip("Cursor 耳机映射", "音量+短按=接受  按住=语音`n播放=发送  音量-=停止", "Iconi")

#HotIf IsCursorFront()

; --- Volume Up: short=accept, hold=voice ---
$*Volume_Up:: {
    global volState, HoldMs
    volState := "pressed"
    SetTimer(VolHoldTimer, -HoldMs)
}

$*Volume_Up Up:: {
    global volState
    SetTimer(VolHoldTimer, 0)
    if (volState = "voice") {
        StopVoice()
    } else if (volState = "pressed") {
        SendInput("^{Enter}")
        Tip("接受更改")
    }
    volState := "idle"
}

; --- Volume Down: stop ---
$Volume_Down:: {
    SendInput("^+{Backspace}")
    Tip("停止生成")
}

; --- Play/Pause: send ---
$Media_Play_Pause:: {
    SendInput("{Enter}")
    Tip("发送")
}

#HotIf
