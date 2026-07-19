#Requires AutoHotkey v2.0
#SingleInstance Force
; Cursor foreground only:
;   Vol+ down/up → Ctrl+M down/up (Agents Window PTT voice)
;   Play/Pause   → Ctrl+Enter (send)
;   Vol-         → Stop generation

ShowTips := true
voiceHeld := false

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

StartVoice() {
    global voiceHeld
    if voiceHeld
        return
    ; Hold Ctrl+M for Agents Window push-to-talk
    Send("{Ctrl down}{m down}")
    voiceHeld := true
    Tip("Ctrl+M 按下")
}

StopVoice() {
    global voiceHeld
    if !voiceHeld
        return
    Send("{m up}{Ctrl up}")
    voiceHeld := false
    Tip("Ctrl+M 松开")
}

OnExit((*) => (
    Send("{m up}{Ctrl up}"),
    voiceHeld := false
))

A_IconTip := "Cursor Headset: Vol+=Ctrl+M | Play=Ctrl+Enter | Vol-=stop"
TrayTip("Cursor 耳机映射", "音量+=按住 Ctrl+M 语音`n播放=Ctrl+Enter发送`n音量-=停止", "Iconi")

#HotIf IsCursorFront()

$*Volume_Up:: {
    StartVoice()
}

$*Volume_Up Up:: {
    StopVoice()
}

$Volume_Down:: {
    Send("^+{Backspace}")
    Tip("停止生成")
}

$Media_Play_Pause:: {
    Send("^{Enter}")
    Tip("发送 Ctrl+Enter")
}

#HotIf
