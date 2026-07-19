#Requires AutoHotkey v2.0
#SingleInstance Force
; Apple wireless headset → Cursor Agent media keys (Cursor foreground only).
; Outside Cursor, media keys pass through to the OS (#HotIf).

; --- Thresholds / mode ---
LongPressMs := 400
DoubleClickMs := 300
; "ptt" = Ctrl+M hold (Agents Window PTT); "toggle" = Ctrl+Shift+Space on press & release
VoiceMode := "ptt"

; State: idle | pressed | voice | shortWait | pressed2
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

; No second click within DoubleClickMs → confirmed short press → Enter.
DoubleClickTimer() {
    global state
    if (state = "shortWait") {
        state := "idle"
        Send("{Enter}")
    }
}

#HotIf WinActive("ahk_exe Cursor.exe")

Volume_Up::Send("^{Enter}")          ; Accept all changes
Volume_Down::Send("^+{Backspace}")   ; Stop generation

; Play/Pause: gesture state machine (short / long / double).
$*Media_Play_Pause:: {
    global state, downTick, LongPressMs

    downTick := A_TickCount

    if (state = "shortWait") {
        ; Second press inside double-click window → cancel pending Enter.
        SetTimer(DoubleClickTimer, 0)
        state := "pressed2"
        return
    }

    state := "pressed"
    SetTimer(LongPressTimer, -LongPressMs)
}

$*Media_Play_Pause Up:: {
    global state, DoubleClickMs

    SetTimer(LongPressTimer, 0)

    if (state = "voice") {
        ; Release after long-press: end voice only (never also Enter).
        EndVoice()
        state := "idle"
        return
    }

    if (state = "pressed2") {
        state := "idle"
        Send("^+{Backspace}")  ; Double-click → stop generation
        return
    }

    if (state = "pressed") {
        ; Short press: wait for possible double-click before Enter.
        state := "shortWait"
        SetTimer(DoubleClickTimer, -DoubleClickMs)
        return
    }
}

#HotIf
