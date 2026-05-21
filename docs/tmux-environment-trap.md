# tmux 环境变量污染排查

## 问题现象

在 Debian 本地图形桌面里使用 WezTerm/Ghostty + tmux 时，偶尔会出现这些现象：

- zsh 新行不再自动把 Rime 切到英文输入模式。
- 新开的 tmux pane 也不正常，但已有 pane 可能仍然正常。
- 打开 Neovim 时提示 `Failed to switch input method`。
- 从另一个终端模拟器执行一次 `tmux a` 后，新 pane 又突然恢复正常。
- 出问题的 pane 里 `DISPLAY` 为空，或 `DBUS_SESSION_BUS_ADDRESS`、`XDG_RUNTIME_DIR` 等图形会话变量缺失。

## 根因

tmux 是长期运行的 server。新建 window/pane 时，进程继承的是 tmux session/server 保存的环境，而不是当前终端模拟器的实时环境。

tmux 的 `update-environment` 会在创建 session 或 attach 已有 session 时，从当前 client 环境刷新一批变量。关键坑点是：如果当前 client 环境里没有某个变量，tmux 会把 session 里的这个变量标记为 removed。之后新开的 pane 就会继承这个被移除后的环境。

例如从家里的 macOS SSH 到 Debian 后执行：

```bash
tmux a
```

SSH shell 通常没有 Debian 本地图形桌面的 `DISPLAY`。这次 attach 会把同一个 tmux session 里的 `DISPLAY` 清掉。回到 Debian 本地 WezTerm/Ghostty 后，新开的 pane 仍然可能没有 `DISPLAY`，直到再次从本地图形终端 attach 并刷新回来。

## 为什么会影响输入法

当前 zsh/Nvim 的自动切换输入法逻辑依赖 fcitx5-rime 的 DBus 接口：

```bash
busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode
busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b true
```

这些调用需要可用的图形会话环境，尤其是：

- `DISPLAY` 或 `WAYLAND_DISPLAY`
- `DBUS_SESSION_BUS_ADDRESS`
- `XDG_RUNTIME_DIR`
- `XAUTHORITY`

如果这些变量在 tmux pane 里缺失，zsh 的 hook 会跳过切换；Neovim 可能退到 `xdotool` fallback，fallback 失败时就会提示 `Failed to switch input method`。

## 快速诊断

在正常 pane 和异常 pane 里分别对比：

```bash
env | rg '^(DISPLAY|WAYLAND_DISPLAY|DBUS_SESSION_BUS_ADDRESS|XDG_RUNTIME_DIR|XAUTHORITY)='
```

查看 tmux session 环境：

```bash
tmux show-environment DISPLAY
tmux show-environment DBUS_SESSION_BUS_ADDRESS
tmux show-environment XDG_RUNTIME_DIR
tmux show-environment XAUTHORITY
```

如果输出类似下面这样，说明变量被 tmux 标记为移除：

```text
-DISPLAY
```

查看 tmux 会在 attach 时刷新哪些变量：

```bash
tmux show-options -g update-environment
```

确认 Rime DBus 接口是否可用：

```bash
busctl --user call org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode
```

## 临时恢复

在 Debian 本地图形终端里重新 attach 一次 tmux，通常可以把 `DISPLAY` 刷回来：

```bash
tmux attach
```

如果需要手动恢复当前 tmux session 环境：

```bash
tmux set-environment DISPLAY "$DISPLAY"
tmux set-environment XAUTHORITY "$XAUTHORITY"
tmux set-environment DBUS_SESSION_BUS_ADDRESS "$DBUS_SESSION_BUS_ADDRESS"
tmux set-environment XDG_RUNTIME_DIR "$XDG_RUNTIME_DIR"
```

恢复后需要新开 pane，已经存在的 shell/Nvim 进程不会自动更新自己的环境。

## 长期规避

### SSH attach 时禁用环境刷新

从 SSH 进入 Debian 后，attach 本地图形 tmux session 时使用 `-E`：

```bash
tmux attach -E
```

`-E` 会让这次 attach 不应用 `update-environment`，避免 SSH 环境清空本地图形 session 的 `DISPLAY`。

可以在 zsh 里加一个 SSH 感知的 wrapper：

```zsh
ta() {
  if [[ -n "${SSH_CONNECTION:-}" || -n "${SSH_TTY:-}" ]]; then
    tmux attach -E "$@"
  else
    tmux attach "$@"
  fi
}
```

如果常用固定 session：

```zsh
tw() {
  if [[ -n "${SSH_CONNECTION:-}" || -n "${SSH_TTY:-}" ]]; then
    tmux new-session -A -E -s work
  else
    tmux new-session -A -s work
  fi
}
```

### SSH 使用单独 tmux socket

更彻底的方式是让本地图形桌面和 SSH 使用不同 tmux server：

```bash
# Debian 本地图形桌面
tmux new -A -s work

# SSH 远程环境
tmux -L ssh new -A -s ssh
```

这样 SSH attach 不会影响本地图形 tmux session 的环境。

### 补全 tmux 刷新变量

tmux 配置里可以补全输入法和图形会话相关变量：

```tmux
set-option -ga update-environment " DBUS_SESSION_BUS_ADDRESS XDG_RUNTIME_DIR WAYLAND_DISPLAY XMODIFIERS GTK_IM_MODULE QT_IM_MODULE"
```

这能让本地图形终端 attach 时刷新更多必要变量，但它不能单独解决 SSH attach 清空变量的问题。SSH 场景仍应使用 `tmux attach -E` 或单独 socket。

## 记忆点

- 本地图形终端 attach：可以让 tmux session 环境恢复到图形桌面状态。
- SSH/TTY attach：可能把图形变量清空。
- SSH attach 本地图形 tmux session：优先用 `tmux attach -E`。
- 经常 SSH 操作同一台机器：优先为 SSH 使用独立 socket，例如 `tmux -L ssh`。
