#Requires AutoHotkey v2.0
#SingleInstance Force
; Apple wireless headset → Cursor Agent media keys (Cursor foreground only).
; Outside Cursor, media keys pass through to the OS (#HotIf).
;
; Note: On many Apple headsets under Windows, "double-tap" does NOT emit two
; Media_Play_Pause events, so double-click gestures are not used. Stop =
; Volume Down only.

; --- Thresholds / mode ---
LongPressMs := 400
; "ptt" = Ctrl+M hold (Agents Window PTT); "toggle" = Ctrl+Shift+Space on press & release
VoiceMode := "ptt"

; State: idle | pressed | voice
state := "idle"
downTick := 0

StartVoice() {
    global VoiceMode
    if (VoiceMode = "ptt")
        Send("{Ctrl down}{m down}")
    else
        Send("^+{Space}")
}

EndVoice() {
    global VoiceMode
    if (VoiceMode = "ptt")
        Send("{m up}{Ctrl up}")
    else
        Send("^+{Space}")
}

; Held past LongPressMs → start voice (no Enter on later release).
LongPressTimer() {
    global state
    if (state = "pressed") {
        state := "voice"
        StartVoice()
    }
}

#HotIf WinActive("ahk_exe Cursor.exe")

Volume_Up::Send("^{Enter}")          ; Accept all changes
Volume_Down::Send("^+{Backspace}")   ; Stop generation

; Play/Pause: short = send; long-hold = voice PTT.
$*Media_Play_Pause:: {
    global state, downTick, LongPressMs

    downTick := A_TickCount
    state := "pressed"
    SetTimer(LongPressTimer, -LongPressMs)
}

$*Media_Play_Pause Up:: {
    global state

    SetTimer(LongPressTimer, 0)

    if (state = "voice") {
        ; Release after long-press: end voice only (never also Enter).
        EndVoice()
        state := "idle"
        return
    }

    if (state = "pressed") {
        ; Short press → send to Agent immediately (no double-click wait).
        state := "idle"
        Send("{Enter}")
        return
    }

    state := "idle"
}

#HotIf
