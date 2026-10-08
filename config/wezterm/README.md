# WezTerm 配置说明

该目录包含可复用的 WezTerm 配置，拆分为 `wezterm.lua`（主配置）、`keybinds.lua`（按键和鼠标）、`utils.lua`（通用函数）。配置的目的在于：

- 统一字体/色彩和窗口外观，兼容中英文；
- 屏蔽默认快捷键，显式配置复制、粘贴、标签新建、切换与关闭；
- 在 Rime 中文状态下按 tmux `Alt+b` prefix 时，自动切到英文模式并继续发送原生 prefix；
- 根据 `~/.ssh/config` 自动生成 SSH Domain，便于在 WezTerm 启动远端会话。

`install.sh` 会将整个目录链接到 `~/.config/wezterm`，因此该目录是 WezTerm
配置的唯一仓库内来源。

## 外观与字体

- 默认主题为 `Teerb`，并将亮黑色调亮以提高 `ls` 等输出可读性。
- 字体使用 `Hack Nerd Font`，并按顺序回退到 `PingFang SC`、`Noto Sans CJK SC`、`Source Han Sans CN` 以兼顾中文显示。
- 隐藏单标签时的标签栏，窗口边距为 0，光标常亮（`cursor_blink_rate = 0`），IME 启用内置预编辑渲染。

## 键鼠绑定

配置禁用了 WezTerm 默认按键，只启用了以下组合（`Prefix` 指 Ctrl+Shift+Space 设定的 leader，可另行映射）：

| 快捷键 | 功能 |
|--------|------|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>c</kbd> | 复制到系统剪贴板 |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>v</kbd> | 从系统剪贴板粘贴 |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>t</kbd> | 在当前域中新建标签页 |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>w</kbd> | 关闭当前标签页及其所有 WezTerm 分屏，需要时提示确认 |
| <kbd>Alt</kbd> + <kbd>b</kbd> | 切换 Rime 到英文模式后发送 tmux prefix |
| <kbd>Alt</kbd> + <kbd>1</kbd> … <kbd>Alt</kbd> + <kbd>6</kbd> | 激活第 1–6 个标签页 |

鼠标操作：

- 左键松开：将选区写入 Primary selection；
- 右键松开：复制到剪贴板；
- <kbd>Ctrl</kbd> + 左键：打开指针所在链接。

如需更多按键，可在 `keybinds.lua` 中补充，或结合 `leader` 自行扩展。

`Alt+b` 的 Rime/tmux 处理细节见 [docs/rime-tmux-prefix.md](docs/rime-tmux-prefix.md)。

## 进程退出与关闭标签页

配置保留 `exit_behavior = "CloseOnCleanExit"`：退出码为 0 时自动关闭对应的
WezTerm pane；非零退出时保留输出和退出提示，便于查看错误。如果这是标签页中
最后一个 pane，关闭 pane 也会关闭标签页。

<kbd>Ctrl</kbd> + <kbd>d</kbd> 是发送给 shell 的 EOF，不是 WezTerm 的关闭动作。
在空提示符按下它会让 zsh 退出；shell 已退出后，再按它也无法关闭保留的标签页。
zsh 退出时会沿用最后一条命令的退出码。例如执行不存在的 `lll` 后，命令未找到的
状态是 `127`，此时直接按 <kbd>Ctrl</kbd> + <kbd>d</kbd> 就会让 zsh 以 `127`
退出，WezTerm 因此保留 pane 并显示 `Exited with code 127`。这是 EOF 与 shell
退出状态的组合结果，不是 WezTerm 或 Awesome WM 的故障；执行 `true` 后再退出，
或直接执行 `exit 0`，可以让标签页自动关闭。

由于 `disable_default_key_bindings = true`，关闭快捷键需要在 `keybinds.lua`
中显式配置：

```lua
{ key = "w", mods = "CTRL|SHIFT", action = act({ CloseCurrentTab = { confirm = true } }) },
```

`confirm = true` 让 WezTerm 根据进程状态决定是否确认：在本地 Linux 上，
进程已经退出的 pane 无需确认；只运行空闲 shell 等默认允许直接关闭的进程时，
也会跳过确认；检测到 vim 等不在跳过列表中的进程时，会显示确认提示。
默认跳过列表包含 `tmux`，因此不能依赖这个确认机制判断 tmux 内部是否有未保存的
工作。关闭动作针对整个 WezTerm 标签页；如需只关闭当前 WezTerm 分屏，可以改用
`CloseCurrentPane`。tmux 内部分屏应使用 tmux 自身的关闭命令。

设置 `confirm = false` 同样能关闭保留的标签页，但会无条件关闭整个标签页并终止
其中的 pane。`window_close_confirmation = "AlwaysPrompt"` 只控制窗口管理器或
窗口装饰触发的关闭，不会为这个快捷键额外提供确认。

如果更希望 shell 退出后始终自动关闭，可以在 `~/.local/share/wezterm/local.lua`
的返回表中添加 `exit_behavior = "Close"`。这样退出码为 255 时也会自动关闭，
但无法保留退出现场。若仅想容忍已知的特定退出码，可使用 `clean_exit_codes`
（例如 `{ 130 }`；0 始终算正常退出）；不建议仅为消除这次提示就把 255 视作成功。
在仍然运行的 shell 中，显式执行 `exit 0` 也能保证正常退出并自动关闭。

修改后可用以下命令检查配置加载和关闭绑定：

```sh
wezterm --config-file ~/.config/wezterm/wezterm.lua show-keys --lua
```

WezTerm 可能将 `Ctrl+Shift+w` 规范化显示为 `key = 'W', mods = 'CTRL'`，
对应的动作应为 `CloseCurrentTab { confirm = true }`。

参考官方文档：[退出行为](https://wezterm.org/config/lua/config/exit_behavior.html)、
[关闭标签页](https://wezterm.org/config/lua/keyassignment/CloseCurrentTab.html)、
[跳过关闭确认的进程](https://wezterm.org/config/lua/config/skip_close_confirmation_for_processes_named.html)、
[窗口关闭确认](https://wezterm.org/config/lua/config/window_close_confirmation.html)、
[正常退出码](https://wezterm.org/config/lua/config/clean_exit_codes.html)。

## 本地覆盖配置

`wezterm.lua` 会尝试加载 `~/.local/share/wezterm/local.lua`，以避免在仓库中保存敏感信息。示例：

```lua
-- ~/.local/share/wezterm/local.lua
return {
  font_size = 12,
  ssh_domains = {
    {
      name = "devbox",
      remote_address = "devbox.internal:22",
      username = "gle",
    },
  },
}
```

此文件会与默认配置深度合并，并可用于调整字体、窗口参数或定义额外的 `ssh_domains`。
注意：数组型字段（`keys`、`mouse_bindings`、`ssh_domains`）为整体替换/追加，不会按下标逐项合并；设为 `{}` 可整体清空（哈希表型字段传 `{}` 则保持原值不变）。

## SSH Domain 自动生成

除了 `local.lua` 中手动配置的项，`wezterm.lua` 会遍历 `wezterm.enumerate_ssh_hosts()`，为 `~/.ssh/config` 内的条目生成 SSH Domain（禁用 mux，假定 POSIX shell）。因此可以直接在 WezTerm 的 “New” 菜单中选择远程主机，无需重复配置。

## 常见自定义入口

- 颜色：可将自定义主题置于 `~/.config/wezterm/colors/` 并通过 `color_scheme_dirs` 加载。
- `selection_word_boundary` 已包含常见分隔符；如需微调可直接修改 `wezterm.lua` 中的字符串。
- `keybinds.lua` 的 `default_keybinds`、`tmux_keybinds` 两段列表可按需求增删，`utils.merge_lists` 会组合它们。记得保持 `mods`/`action` 字段与 WezTerm API 一致。
