#Requires AutoHotkey v2.0
#SingleInstance Force
; Probe: log whether Apple headset media keys reach Windows.
; Uses ~ (passthrough) so keys are NOT swallowed — safe to run alongside
; cursor-headset.ahk, or alone. Prefer exiting probe when done testing.

LogPath := A_ScriptDir "\probe-keys.log"

Log(msg) {
    global LogPath
    line := FormatTime(, "yyyy-MM-dd HH:mm:ss") "." A_MSec "  " msg
    try FileAppend(line "`n", LogPath, "UTF-8")
    ToolTip(msg)
    SetTimer(() => ToolTip(), -2000)
}

downTick := 0

Log("probe-keys started (passthrough) — Volume / Play-Pause / double-tap / long-press")

; ~ = pass through to OS and other scripts (do not block).
~Volume_Up::Log("Volume_Up")
~Volume_Down::Log("Volume_Down")

~*Media_Play_Pause:: {
    global downTick
    downTick := A_TickCount
    Log("Media_Play_Pause Down")
}

~*Media_Play_Pause Up:: {
    global downTick
    held := A_TickCount - downTick
    Log("Media_Play_Pause Up  hold=" held "ms")
}

~Media_Next::Log("Media_Next (often = double-tap forward)")
~Media_Prev::Log("Media_Prev (often = double-tap back / triple-tap)")
~Media_Stop::Log("Media_Stop")
