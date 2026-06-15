# LXTerminal 配置说明

这个目录保存 LXTerminal 的主配置文件：

- `lxterminal.conf`: LXTerminal 自身读取的配置，包含字体、配色、快捷键、标签页位置、标签页宽度等。

当前配置最初是按 `../wezterm` 里的 WezTerm 配置转换来的，主要对齐了字体、配色、隐藏菜单栏、隐藏滚动条、快捷键和标签页行为。

## 输入法与 tmux prefix

WezTerm 配置里有一段专门处理 Rime 中文状态下 tmux `Alt+b` prefix 的逻辑：

1. WezTerm 截获 `Alt+b`。
2. 通过 fcitx5-rime DBus 接口检查 Rime 是否已经是英文模式。
3. 必要时调用 `SetAsciiMode b true`。
4. 再把原始 `Alt+b` 发送给当前 pane，让 tmux 继续按原生 prefix 流程处理。

这段逻辑不能只靠 `lxterminal.conf` 迁移。LXTerminal 0.4.1 的配置只支持固定的
GTK 菜单快捷键和少量终端外观/行为开关；`[shortcut]` 里的键会被绑定到
`File_NewTab`、`Edit_Copy`、`Tabs_NextTab` 这类内置菜单动作，不能绑定任意脚本，
也不能在脚本执行后把同一个按键继续发送给 VTE/tmux。

源码里的相关边界也一致：

- `src/setting.h` 只定义了固定配置键，没有 IME、preedit、任意 key callback 或外部命令配置项。
- `src/lxterminal.c` 中 `disablealt` 只控制 `Alt+1` 到 `Alt+9` 的标签页切换，不影响 `Alt+b`。
- 菜单快捷键通过 `gtk_accel_map_change_entry()` 绑定到固定菜单 action，不能实现
  WezTerm 的 `action_callback`。

因此当前可迁移到 LXTerminal 配置层的只有普通快捷键和 GTK/VTE 自带的输入法行为；
Rime/tmux prefix 这块不能在本目录的 `lxterminal.conf` 中等价实现。

如果一定要在 LXTerminal 下获得同等效果，需要把逻辑放到配置层以外：

- 改 LXTerminal 源码/本地补丁：在 VTE 收到 `Alt+b` 前处理 key event，先调用
  fcitx5-rime DBus，再向 pty 写入 tmux 需要的 `Alt+b` 序列。
- 放到窗口管理器或独立按键守护进程：拦截面向 LXTerminal 的 `Alt+b`，先切 Rime
  到英文，再合成 `Alt+b`。这个方案要谨慎处理 Alt 修饰键状态，否则容易干扰
  Awesome WM 自己的 `Alt+j/k/h/l` 等快捷键。
- 继续使用 WezTerm 承载这项功能；这是当前配置中最可靠的实现位置。

对应的 WezTerm 细节见：

```text
../wezterm/docs/rime-tmux-prefix.md
```

## `lxterminal.conf`

常用字段：

- `fontname`: 终端字体。当前使用 Hack Nerd Font，并配置中文 fallback。
- `bgcolor` / `fgcolor` / `palette_color_*`: 终端背景、前景和 16 色调色板。
- `tabpos=top`: 标签页在窗口顶部。
- `hidescrollbar=true`: 隐藏滚动条。
- `hidemenubar=true`: 隐藏菜单栏。
- `hideclosebutton=true`: 隐藏标签页关闭按钮。
- `hidepointer=true`: 输入时隐藏鼠标指针。
- `tabwidth=100`: 标签页宽度，只影响宽度，不影响高度。
- `[shortcut]`: 快捷键配置。

注意：LXTerminal 0.4.1 的配置文件没有标签页高度选项。`tabwidth` 只会传给标签文字控件的宽度请求，不能压低顶部标签栏。

## 顶部标签栏高度

顶部标签栏高度由 GTK3 的 `GtkNotebook` 主题样式决定，不在 `lxterminal.conf` 中配置。

当前压缩标签栏高度的配置在：

```text
../gtk-3.0/gtk.css
```

相关规则：

```css
/* Compact the LXTerminal top tab bar. */
window > box > notebook > header.top {
  min-height: 0;
  margin: 0;
  padding: 0;
  border-width: 0 0 1px 0;
}

window > box > notebook > header.top > tabs {
  min-height: 0;
  margin: 0;
  padding: 0;
}

window > box > notebook > header.top > tabs > tab {
  min-height: 18px;
  margin: 0;
  padding: 0 6px;
}

window > box > notebook > header.top > tabs > tab label {
  min-height: 0;
  margin: 0;
  padding: 0;
  font-size: 9pt;
}

window > box > notebook > header.top > tabs > tab button {
  min-height: 0;
  min-width: 0;
  margin: 0;
  padding: 0;
}
```

这个选择器按 LXTerminal 主窗口结构限定到顶部 `GtkNotebook` 标签栏。LXTerminal 本身没有设置专用 GTK application id、widget name 或 CSS class，所以不能写成完全精确的 `.lxterminal ...` 规则。

修改 `gtk.css` 后，需要重新打开 LXTerminal 窗口才会生效。当前验证过：同样 `80x24`、两个标签页的窗口高度从约 `567px` 降到约 `556px`。
