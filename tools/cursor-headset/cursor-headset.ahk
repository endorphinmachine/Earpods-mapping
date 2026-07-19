#Requires AutoHotkey v2.0
#SingleInstance Force
; Apple wireless headset → Cursor Agent media keys (Cursor foreground only).
; Outside Cursor, media keys pass through to the OS (#HotIf).
;
; Note: On many Apple headsets under Windows, "double-tap" does NOT emit two
; Media_Play_Pause events, so double-click gestures are not used. Stop =
; Volume Down only.
;
; Voice mapping is OFF by default: Cursor voice / BT Hands-Free switching
; often breaks Apple headset mics on Windows. Set EnableVoice := true only
; after mic works with Hands-Free AG Audio selected as input.

; --- Thresholds / mode ---
LongPressMs := 400
EnableVoice := false
; "ptt" = Ctrl+M hold (Agents Window PTT); "toggle" = Ctrl+Shift+Space on press & release
VoiceMode := "ptt"

; State: idle | pressed | voice
state := "idle"
downTick := 0
voiceHeld := false

ReleaseModifiers() {
    global voiceHeld, VoiceMode
    if (voiceHeld) {
        if (VoiceMode = "ptt")
            Send("{m up}{Ctrl up}")
        voiceHeld := false
    }
    ; Always clear stuck modifiers that PTT might leave behind.
    Send("{Ctrl up}{Shift up}{Alt up}")
}

StartVoice() {
    global VoiceMode, voiceHeld, EnableVoice
    if (!EnableVoice)
        return
    if (VoiceMode = "ptt") {
        Send("{Ctrl down}{m down}")
        voiceHeld := true
    } else {
        Send("^+{Space}")
        voiceHeld := true
    }
}

EndVoice() {
    global VoiceMode, voiceHeld, EnableVoice
    if (!EnableVoice)
        return
    if (VoiceMode = "ptt") {
        Send("{m up}{Ctrl up}")
    } else if (voiceHeld) {
        Send("^+{Space}")
    }
    voiceHeld := false
}

; Held past LongPressMs → start voice (no Enter on later release).
LongPressTimer() {
    global state, EnableVoice
    if (state = "pressed") {
        if (EnableVoice) {
            state := "voice"
            StartVoice()
        }
        ; If voice disabled, stay in "pressed"; release will still Send Enter.
    }
}

OnExit((*) => ReleaseModifiers())

#HotIf WinActive("ahk_exe Cursor.exe")

Volume_Up::Send("^{Enter}")          ; Accept all changes
Volume_Down::Send("^+{Backspace}")   ; Stop generation

; Play/Pause: short = send; long-hold = voice PTT (only if EnableVoice).
$*Media_Play_Pause:: {
    global state, downTick, LongPressMs, EnableVoice

    downTick := A_TickCount
    state := "pressed"
    if (EnableVoice)
        SetTimer(LongPressTimer, -LongPressMs)
}

$*Media_Play_Pause Up:: {
    global state, EnableVoice

    SetTimer(LongPressTimer, 0)

    if (state = "voice") {
        ; Release after long-press: end voice only (never also Enter).
        EndVoice()
        state := "idle"
        return
    }

    if (state = "pressed") {
        ; Short press (or long press with voice disabled) → send to Agent.
        state := "idle"
        Send("{Enter}")
        return
    }

    state := "idle"
}

#HotIf
