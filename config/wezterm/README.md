# WezTerm 配置说明

该目录包含可复用的 WezTerm 配置，拆分为 `wezterm.lua`（主配置）、`keybinds.lua`（按键和鼠标）、`utils.lua`（通用函数）。配置的目的在于：

- 统一字体/色彩和窗口外观，兼容中英文；
- 屏蔽默认快捷键，只保留常用的复制、粘贴与标签切换；
- 根据 `~/.ssh/config` 自动生成 SSH Domain，便于在 WezTerm 启动远端会话。

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
| <kbd>Alt</kbd> + <kbd>1</kbd> … <kbd>Alt</kbd> + <kbd>6</kbd> | 激活第 1–6 个标签页 |

鼠标操作：

- 左键松开：将选区写入 Primary selection；
- 右键松开：复制到剪贴板；
- <kbd>Ctrl</kbd> + 左键：打开指针所在链接。

如需更多按键，可在 `keybinds.lua` 中补充，或结合 `leader` 自行扩展。

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

## SSH Domain 自动生成

除了 `local.lua` 中手动配置的项，`wezterm.lua` 会遍历 `wezterm.enumerate_ssh_hosts()`，为 `~/.ssh/config` 内的条目生成 SSH Domain（禁用 mux，假定 POSIX shell）。因此可以直接在 WezTerm 的 “New” 菜单中选择远程主机，无需重复配置。

## 常见自定义入口

- 颜色：可将自定义主题置于 `~/.config/wezterm/colors/` 并通过 `color_scheme_dirs` 加载。
- `selection_word_boundary` 已包含常见分隔符；如需微调可直接修改 `wezterm.lua` 中的字符串。
- `keybinds.lua` 的 `default_keybinds`、`tmux_keybinds` 两段列表可按需求增删，`utils.merge_lists` 会组合它们。记得保持 `mods`/`action` 字段与 WezTerm API 一致。
