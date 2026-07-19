#Requires AutoHotkey v2.0
#SingleInstance Force
; Apple wireless headset → Cursor Agent media keys (Cursor foreground only).
; Outside Cursor, media keys pass through to the OS (#HotIf).
;
; Play/Pause short click = toggle Cursor voice (hold-to-talk breaks Apple mic
; on Windows while the button is held). Long press = send message instead.

; --- Thresholds / mode ---
LongPressMs := 400
; "toggle" = Ctrl+Shift+Space (Cursor Voice Mode)
; "ptt"    = Ctrl+M (Agents Window only; not used for short-click toggle)
VoiceMode := "toggle"
ShowTips := true

; State: idle | pressed
state := "idle"
downTick := 0

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

ToggleVoice() {
    global VoiceMode
    if (VoiceMode = "ptt") {
        ; No true toggle for PTT; fall back to Voice Mode shortcut.
        SendInput("^+{Space}")
    } else {
        SendInput("^+{Space}")
    }
    Tip("语音 开/关")
}

; Held past LongPressMs → send (do not also toggle voice on release).
LongPressTimer() {
    global state
    if (state = "pressed") {
        state := "idle"
        SendInput("{Enter}")
        Tip("发送")
    }
}

A_IconTip := "Cursor Headset — click=voice  long-press=send"
TrayTip("Cursor 耳机映射已启动", "短按播放=语音开关`n长按播放=发送`n音量+=接受  音量-=停止", "Iconi")

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
    global state, downTick, LongPressMs

    downTick := A_TickCount
    state := "pressed"
    SetTimer(LongPressTimer, -LongPressMs)
}

$*Media_Play_Pause Up:: {
    global state

    SetTimer(LongPressTimer, 0)

    if (state = "pressed") {
        ; Short click → toggle voice on/off (release before long-press threshold).
        state := "idle"
        ToggleVoice()
        return
    }

    ; Long press already sent Enter in LongPressTimer; ignore release.
    state := "idle"
}

#HotIf
