#Requires AutoHotkey v2.0
#SingleInstance Force
; Cursor foreground only:
;   Vol+ down/up     → Ctrl+M down/up (Agents Window PTT voice)
;   Play/Pause       → Ctrl+Enter (send)
;   Vol- short       → Stop generation
;   Vol- long        → Clear chat input (Ctrl+A, Delete)

HoldMs := 400
ShowTips := true
voiceHeld := false
; vol- state: idle | pressed | cleared
volDownState := "idle"

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

ClearChatInput() {
    ; Select all in focused input, then delete
    Send("^a")
    Sleep(30)
    Send("{Delete}")
    Tip("清空输入")
}

VolDownHoldTimer() {
    global volDownState
    if (volDownState = "pressed") {
        volDownState := "cleared"
        ClearChatInput()
    }
}

OnExit((*) => (
    Send("{m up}{Ctrl up}"),
    voiceHeld := false
))

A_IconTip := "Cursor Headset: Vol+=Ctrl+M | Play=send | Vol-=stop/clear"
TrayTip("Cursor 耳机映射", "音量+=Ctrl+M语音`n播放=Ctrl+Enter发送`n音量-短按=停止 长按=清空输入", "Iconi")

#HotIf IsCursorFront()

$*Volume_Up:: {
    StartVoice()
}

$*Volume_Up Up:: {
    StopVoice()
}

$*Volume_Down:: {
    global volDownState, HoldMs
    volDownState := "pressed"
    SetTimer(VolDownHoldTimer, -HoldMs)
}

$*Volume_Down Up:: {
    global volDownState
    SetTimer(VolDownHoldTimer, 0)
    if (volDownState = "pressed") {
        Send("^+{Backspace}")
        Tip("停止生成")
    }
    ; if cleared, long-press already handled — do not also stop
    volDownState := "idle"
}

$Media_Play_Pause:: {
    Send("^{Enter}")
    Tip("发送 Ctrl+Enter")
}

#HotIf
