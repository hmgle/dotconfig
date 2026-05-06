# Rime 中文状态下使用 tmux Alt+b prefix

## 背景

当前桌面输入链路是：

```text
键盘 -> Awesome WM / WezTerm -> fcitx5-rime -> tmux -> shell / nvim
```

tmux prefix 配置为 `Alt+b`：

```tmux
set -g prefix M-b
unbind C-b
bind M-b send-prefix
```

问题表现是：在 Rime 中文状态下，按 `Alt+b` 以后再按 `j/k/h/l` 等 tmux
prefix 绑定，普通字母键会先被 Rime 当作拼音输入拦截，tmux 收不到命令键。
必须再按一次 Shift 切到英文，tmux 绑定才会触发。

目标是：按下 `Alt+b` 时立即把 Rime 切到英文模式，然后仍按 tmux 原生 prefix
流程处理后续按键。

## 最终方案

最终实现放在 WezTerm，而不是 tmux 或 Rime：

1. WezTerm 截获 `Alt+b`。
2. 通过 fcitx5-rime 暴露的 DBus 接口检查 Rime 是否已经是英文模式。
3. 只有当前不是英文模式时，才设置 Rime `ascii_mode=true`。
4. WezTerm 再把 `Alt+b` 发送给当前 pane，让 tmux 原生 prefix 正常生效。

当前配置在 `~/.config/wezterm/keybinds.lua`：

```lua
local ensure_rime_ascii_mode = [[
if ! busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode 2>/dev/null | grep -q 'b true'; then
  busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b true >/dev/null 2>&1 || true
fi
]]

local function switch_rime_to_en_and_send_tmux_prefix(window, pane)
  wezterm.run_child_process({ "sh", "-lc", ensure_rime_ascii_mode })
  window:perform_action(act.SendKey({ key = "b", mods = "ALT" }), pane)
end

M.tmux_keybinds = {
  { key = "b", mods = "ALT", action = wezterm.action_callback(switch_rime_to_en_and_send_tmux_prefix) },
}
```

这个方案不会改变 tmux 的 prefix 配置。tmux 仍然保持：

```tmux
set -g prefix M-b
unbind C-b
bind M-b send-prefix
```

## 为什么不用 tmux 直接切换

曾尝试把 tmux prefix 改成 root key binding：

```tmux
set -g prefix None
bind-key -n M-b run-shell ... \; switch-client -T prefix
```

这个方向有两个问题：

- 它不再是 tmux 原生 prefix，只是临时切换 key table，时序和容错都更差。
- 如果在这里用 `xdotool --clearmodifiers` 模拟按键，会释放/恢复 Alt，干扰
  Awesome WM 看到的修饰键状态，导致 `Alt+b` 后的 `j` 有时变成 WM 的
  `Alt+j` 快捷键。

因此 tmux 不适合作为执行输入法切换的地方。tmux 应继续只负责 prefix。

## 为什么不用 Rime 的 Alt_L

曾尝试在 `default.custom.yaml` 中添加：

```yaml
patch:
  ascii_composer/switch_key/Alt_L: clear
```

该配置可以进入 Rime build 产物，但在 WezTerm + fcitx5-rime 的路径里，
Rime 没有可靠收到“单独按下左 Alt”这个事件。结果是 `Alt+b` 后的下一枚
`j/k/h/l` 仍然会被 Rime 中文状态拦截。

因此不能依赖 Rime 自己处理 `Alt_L` 来解决 tmux prefix。

## 为什么不用 fcitx5-remote -c

`fcitx5-remote -c` 的含义是让 fcitx 输入法 inactive。它对当前 Rime 方案的
`ascii_mode` 不够可靠，实际测试中执行前后状态可能仍然不能让 prefix 后的字母
绕过 Rime。

fcitx5-rime 提供了更精确的 DBus 接口：

```sh
busctl --user call \
  org.fcitx.Fcitx5 \
  /rime \
  org.fcitx.Fcitx.Rime1 \
  SetAsciiMode b true
```

这个接口直接设置 Rime 的英文模式，是最终方案使用的切换方式。
实际 WezTerm 配置会先调用 `IsAsciiMode`，当前已经是英文时不会重复调用
`SetAsciiMode`，避免 fcitx/Rime 反复显示状态提示。

## 相关 Rime 配置

`~/.local/share/fcitx5/rime/default.custom.yaml` 中保留了一个强制英文快捷键：

```yaml
patch:
  key_binder/bindings/+:
    - { when: always, accept: "Control+Alt+Shift+F12", set_option: ascii_mode }
```

这主要供 Neovim 的 `InsertLeave` 自动切换逻辑使用。tmux prefix 方案不依赖
这个快捷键；它直接通过 DBus 设置 Rime 状态。

修改 Rime YAML 后需要重新部署：

```sh
rime_deployer --build ~/.local/share/fcitx5/rime
fcitx5-remote -r
```

## 验证命令

确认 fcitx5-rime DBus 接口存在：

```sh
busctl --user introspect org.fcitx.Fcitx5 /rime
```

应能看到：

```text
org.fcitx.Fcitx.Rime1.SetAsciiMode method b -
org.fcitx.Fcitx.Rime1.IsAsciiMode  method - b
```

手动切换 Rime 到英文：

```sh
busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b true
```

查看当前 Rime 是否英文模式：

```sh
busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode
```

查看 WezTerm 是否注册了 `Alt+b`：

```sh
wezterm --config-file ~/.config/wezterm/wezterm.lua show-keys --lua | rg "key = 'b'|ALT|user-defined"
```

查看 tmux prefix：

```sh
tmux show-option -g prefix
tmux list-keys -T prefix M-b
```

## 故障排查

如果 `Alt+b` 在中文状态下又失效，按顺序检查：

1. WezTerm 配置是否重新加载。必要时重开 WezTerm 窗口。
2. `wezterm show-keys --lua` 是否能看到 `key = 'b', mods = 'ALT'` 的用户回调。
3. `busctl --user introspect org.fcitx.Fcitx5 /rime` 是否仍有 `SetAsciiMode`。
4. `tmux show-option -g prefix` 是否仍是 `M-b`。
5. 如果英文状态下仍反复出现输入法状态提示，确认 WezTerm 配置里是先检查
   `IsAsciiMode`，而不是无条件调用 `SetAsciiMode b true`。
6. 不要在 tmux 里重新引入 `xdotool --clearmodifiers`，它会影响 Awesome WM
   的 Alt 状态。

如果换终端模拟器，这套 WezTerm key callback 方案不会自动迁移。需要在新终端
或窗口管理器层做等价逻辑：先调用 Rime DBus `IsAsciiMode` 判断状态，必要时再
调用 `SetAsciiMode b true`，最后把 `Alt+b` 发送给 tmux。

## Zsh 新命令开头自动切英文

zsh 命令行可以做类似优化，但适合放在 zsh 的 ZLE 层，而不是 WezTerm：

1. ZLE 只在 shell 正在编辑命令行时运行，因此不会影响 `codex`、`nvim`、`fzf`
   等子进程自己的输入界面。
2. `line-init` hook 会在新命令行开始编辑时触发。
3. hook 里检查 `BUFFER`、`LBUFFER`、`RBUFFER` 全为空，确认当前是空白的新命令
   行；如果已经有 `echo ` 之类的左侧内容，则不会切换。
4. 通过同一个 fcitx5-rime DBus 接口，仅在当前不是英文模式时设置
   `ascii_mode=true`。

当前实现放在 `~/.zshrc`：

```zsh
__rime_ensure_ascii_mode() {
  [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]] || return 0
  [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]] || return 0
  (( $+commands[busctl] )) || return 0

  busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode 2>/dev/null \
    | command grep -q 'b true' \
    || busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b true >/dev/null 2>&1
}

__rime_ascii_mode_on_empty_zle_line() {
  [[ -o interactive ]] || return 0
  [[ -z "${BUFFER:-}" && -z "${LBUFFER:-}" && -z "${RBUFFER:-}" ]] || return 0

  __rime_ensure_ascii_mode
}

if [[ -o interactive ]]; then
  autoload -Uz add-zle-hook-widget
  add-zle-hook-widget line-init __rime_ascii_mode_on_empty_zle_line
fi
```

这个方案的刻意边界是：它只处理 zsh 新 prompt 出现时的空命令行。如果已经开始
编辑命令，例如光标在 `echo ` 后面准备输入中文，`BUFFER` 不为空，不会自动切换。
如果用户在空 prompt 出现以后又手动切回中文，zsh 无法可靠收到这个输入法状态变化；
下一次新 prompt 出现时会再次自动切回英文。
