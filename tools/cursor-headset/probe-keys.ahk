#Requires AutoHotkey v2.0
#SingleInstance Force
; Probe: log whether Apple headset media keys reach Windows.
; Run this (Cursor does not need to be focused). Check ToolTip + probe-keys.log.

LogPath := A_ScriptDir "\probe-keys.log"

Log(msg) {
    global LogPath
    line := FormatTime(, "yyyy-MM-dd HH:mm:ss") "." A_MSec "  " msg
    try FileAppend(line "`n", LogPath, "UTF-8")
    ToolTip(msg)
    SetTimer(() => ToolTip(), -2000)
}

downTick := 0

Log("probe-keys started — press Volume Up/Down and Play/Pause on the headset")

Volume_Up:: {
    Log("Volume_Up")
}

Volume_Down:: {
    Log("Volume_Down")
}

*Media_Play_Pause:: {
    global downTick
    downTick := A_TickCount
    Log("Media_Play_Pause Down")
}

*Media_Play_Pause Up:: {
    global downTick
    held := A_TickCount - downTick
    Log("Media_Play_Pause Up  hold=" held "ms")
}
