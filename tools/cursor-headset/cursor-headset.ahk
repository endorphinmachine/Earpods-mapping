#Requires AutoHotkey v2.0
#SingleInstance Force
; Apple wireless headset → Cursor Agent media keys (Cursor foreground only).
; Outside Cursor, media keys pass through to the OS (#HotIf).
;
; IMPORTANT: Exit probe-keys.ahk if you used an older version without ~ —
; that version globally swallowed Volume / Play-Pause and looked like
; "volume mapping broken". Current probe uses passthrough.

; --- Thresholds / mode ---
LongPressMs := 400
EnableVoice := true
; "toggle" = Ctrl+Shift+Space (Cursor Voice Mode, recommended)
; "ptt"    = Ctrl+M hold (Agents Window push-to-talk only)
VoiceMode := "toggle"
; Brief on-screen confirm when a mapping fires (set false once stable)
ShowTips := true

; State: idle | pressed | voice
state := "idle"
downTick := 0
voiceHeld := false

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
    global voiceHeld, VoiceMode
    if (voiceHeld && VoiceMode = "ptt")
        SendInput("{m up}{Ctrl up}")
    voiceHeld := false
    SendInput("{Ctrl up}{Shift up}{Alt up}")
}

StartVoice() {
    global VoiceMode, voiceHeld, EnableVoice
    if (!EnableVoice)
        return
    if (VoiceMode = "ptt") {
        SendInput("{Ctrl down}{m down}")
        voiceHeld := true
    } else {
        ; Toggle Voice Mode on
        SendInput("^+{Space}")
        voiceHeld := true
    }
    Tip("语音：开")
}

EndVoice() {
    global VoiceMode, voiceHeld, EnableVoice
    if (!EnableVoice)
        return
    if (VoiceMode = "ptt") {
        SendInput("{m up}{Ctrl up}")
    } else if (voiceHeld) {
        ; Toggle Voice Mode off
        SendInput("^+{Space}")
    }
    voiceHeld := false
    Tip("语音：关")
}

LongPressTimer() {
    global state, EnableVoice
    if (state = "pressed" && EnableVoice) {
        state := "voice"
        StartVoice()
    }
}

OnExit((*) => ReleaseModifiers())

A_IconTip := "Cursor Headset — Voice=" (EnableVoice ? VoiceMode : "off")
TrayTip("Cursor 耳机映射已启动", "语音=" (EnableVoice ? VoiceMode : "关") "`n音量+=接受  音量-=停止  短按播放=发送", "Iconi")

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
    global state, downTick, LongPressMs, EnableVoice

    downTick := A_TickCount
    state := "pressed"
    if (EnableVoice)
        SetTimer(LongPressTimer, -LongPressMs)
}

$*Media_Play_Pause Up:: {
    global state

    SetTimer(LongPressTimer, 0)

    if (state = "voice") {
        EndVoice()
        state := "idle"
        return
    }

    if (state = "pressed") {
        state := "idle"
        SendInput("{Enter}")
        Tip("发送")
        return
    }

    state := "idle"
}

#HotIf
