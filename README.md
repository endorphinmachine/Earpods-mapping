# Earpods-mapping

将苹果无线耳机媒体键映射到 Cursor Agent 常用操作（仅 Cursor 前台时生效）。

## 计划键位

| 耳机操作 | Cursor 动作 |
|---------|------------|
| 短按 播放/暂停 | 发送给 Agent |
| 长按 播放/暂停（按住/松开） | 开始/结束语音输入 |
| 双击 播放/暂停 | 停止生成 |
| 音量加 | 接受更改 |
| 音量减 | 停止生成 |

实现方式：Windows + AutoHotkey v2。详见后续 `tools/cursor-headset/`。
