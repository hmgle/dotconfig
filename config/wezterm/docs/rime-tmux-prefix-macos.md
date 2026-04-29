# macOS Squirrel 中文状态下使用 tmux prefix

## 背景

macOS 上当前输入链路是：

```text
键盘 -> WezTerm -> Squirrel / Rime -> tmux -> shell / nvim
```

tmux prefix 配置为 `C-g`：

```tmux
set -g prefix C-g
unbind C-b
bind C-g send-prefix
```

WezTerm 中使用 `Cmd+b` 发送 `C-g`：

```lua
{ key = "b", mods = "CMD", action = wezterm.action.SendString("\x07") }
```

问题表现是：在 Squirrel / Rime 中文状态下，按 `Cmd+b` 以后再按 tmux
prefix 绑定中的 `j/k/h/l`，后续普通字母可能先被 Rime 当作拼音输入拦截，
tmux 收不到 prefix 命令键。

同类问题也会出现在 tmux copy-mode 中：`Cmd+b [` 可以进入 copy-mode，但随后
按 `j/k/h/l` 移动时仍处于中文输入状态，普通字母会再次被 Rime 拦截。

Linux 上的 fcitx5-rime 方案可以在 prefix 触发时通过 DBus 设置
`ascii_mode=true`。macOS 的 Squirrel 没有等价的公开接口，所以不能直接复刻。

## 可行性结论

完整等价的 Linux 行为在 macOS + Squirrel 下不可行：

- fcitx5-rime 有 DBus `SetAsciiMode` / `IsAsciiMode`，可以精确控制当前 Rime
  状态。
- Squirrel 没有公开的 CLI、DBus 或稳定 IPC 可以对当前 Rime session 执行
  `set_option("ascii_mode", true)`。
- Squirrel 的 `app_options` 只适合设置应用级默认选项，不是 prefix 级热键钩子。
- 在 WezTerm key callback 里调用 `osascript` 切 macOS 输入源会引入时序问题，
  可能让 tmux prefix 自身变得不稳定。

因此最终采用 WezTerm 转发替代：让 WezTerm 在 `Cmd+b` 之后短暂接管后续按键，
并把它直接发给 tmux。当前配置包含两层转发表：一张覆盖常见 tmux prefix 输入，
另一张在进入 tmux copy-mode 后持续覆盖 copy-mode 的 vi 操作键，绕开 Rime 对
普通字母的预编辑。

## 已验证失败的方向

### Squirrel app_options

曾尝试在 `~/Library/Rime/squirrel.custom.yaml` 中设置：

```yaml
patch:
  app_options:
    com.github.wez.wezterm:
      ascii_mode: true
      vim_mode: true
```

配置可以进入 `~/Library/Rime/build/squirrel.yaml`，但对当前问题无效。原因是
Squirrel 只在客户端应用变化或新建 Rime session 时应用 `app_options`，并不会
在每次 tmux prefix 前重新设置 `ascii_mode`。如果已经在 WezTerm 当前输入会话中
切到了中文，`app_options` 不会在 `Cmd+b` 时再次强制切英文。

相关源码：

- Squirrel 0.16.2 在 app 变化时调用 `updateAppOptions()`：
  <https://github.com/rime/squirrel/blob/0.16.2/SquirrelInputController.m#L68-L72>
- 新建 session 和 `updateAppOptions()` 的实现：
  <https://github.com/rime/squirrel/blob/0.16.2/SquirrelInputController.m#L467-L490>
- Rime 定制指南中的 `app_options` 用法：
  <https://github.com/rime/home/wiki/CustomizationGuide#在特定程序裏關閉中文輸入>

### WezTerm 中调用 osascript 切输入源

曾尝试在 `Cmd+b` 回调里先调用 macOS Text Input Sources API：

```sh
osascript -l JavaScript
```

内部调用 `TISCopyInputSourceForLanguage("en")` 和 `TISSelectInputSource`，再向
pane 发送 `\x07`。这可以切到英文输入源，但不适合放在 prefix 热路径里：

- `osascript` 启动和 macOS 输入源切换有明显时序成本。
- tmux prefix 是瞬时状态，回调里的延迟会导致 `C-g` 和下一枚键的相对顺序不稳。
- 实测会出现英文状态下 `prefix+j/k/h/l` 也偶发失效。

这个方向应避免继续使用。

### 依赖 Squirrel 公开命令

Squirrel 二进制支持 `--build`、`--reload`、`--sync` 等管理操作，但没有公开的
`set-option ascii_mode true` 或类似接口。没有这个接口，外部程序无法像 Linux
fcitx5-rime DBus 方案那样精确修改当前 Rime session 的状态。

## 最终替代方案

当前 macOS 方案放在 WezTerm：

1. `Cmd+b` 仍然先发送 tmux prefix `C-g`，保持 tmux 原生 prefix 路径。
2. 同时激活一个 WezTerm `tmux_prefix` key table。
3. 这个 key table 在 3 秒内、一次性捕获 prefix 后续键。
4. 被捕获的键由 WezTerm 直接 `SendString` 或 `SendKey` 给 pane，避免被
   Rime 当作拼音输入。
5. 如果 prefix 后续键是 `[` 或 `PageUp`，说明会进入 tmux copy-mode，同时再
   激活一个持续的 `tmux_copy_mode` key table。
6. tmux 仍然负责解释 prefix 后续键，WezTerm 只做输入转发。

当前本机配置在 `~/.config/wezterm/keybinds.lua`。下面摘出 prefix 转发和
copy-mode 入口的关键结构，完整实现还包括 `tmux_copy_mode` 和
`tmux_copy_prompt` 的生成函数：

```lua
M.tmux_keybinds = {
  {
    key = "b",
    mods = "CMD",
    action = act.Multiple({
      act.SendString("\x07"),
      act.ActivateKeyTable({
        name = "tmux_prefix",
        one_shot = true,
        timeout_milliseconds = 3000,
      }),
    }),
  },
}

local function tmux_prefix_key(key)
  return act.SendString(key)
end

local function tmux_prefix_send_key(key, mods)
  return act.SendKey({ key = key, mods = mods or "NONE" })
end

local function activate_tmux_copy_mode()
  return act.ActivateKeyTable({
    name = "tmux_copy_mode",
    one_shot = false,
    replace_current = true,
    timeout_milliseconds = 600000,
  })
end

local function create_tmux_prefix_key_table()
  local keys = {}

  local function send_action(key, action, mods)
    table.insert(keys, {
      key = key,
      mods = mods or "NONE",
      action = action,
    })
  end

  local function send_string(key, value, mods)
    table.insert(keys, {
      key = key,
      mods = mods or "NONE",
      action = tmux_prefix_key(value or key),
    })
  end

  local function send_key(key, mods, send_mods)
    table.insert(keys, {
      key = key,
      mods = mods or "NONE",
      action = tmux_prefix_send_key(key, send_mods or mods or "NONE"),
    })
  end

  local function send_physical_key(key, send_key_name, mods, send_mods)
    table.insert(keys, {
      key = "phys:" .. key,
      mods = mods or "NONE",
      action = tmux_prefix_send_key(send_key_name or key, send_mods or mods or "NONE"),
    })
  end

  send_string("Space", " ")
  for i = 33, 126 do
    local key = string.char(i)
    if key ~= "[" then
      send_string(key)
    end

    if key ~= "[" and (key:match("%u") or key:match("%p")) then
      send_string(key, key, "SHIFT")
    end
  end

  local enter_tmux_copy_mode = act.Multiple({
    tmux_prefix_key("["),
    activate_tmux_copy_mode(),
  })
  send_action("[", enter_tmux_copy_mode)
  send_action("[", enter_tmux_copy_mode, "SHIFT")

  for i = 97, 122 do
    send_string(string.char(i), string.char(i - 96), "CTRL")
    send_key(string.char(i), "ALT")
  end

  for i = 65, 90 do
    local key = string.char(i)
    send_key(key, "ALT")
    send_key(key, "ALT|SHIFT", "ALT|SHIFT")
  end

  for i = 48, 57 do
    send_key(string.char(i), "ALT")
  end

  for _, key in ipairs({ "UpArrow", "DownArrow", "LeftArrow", "RightArrow" }) do
    send_key(key)
    send_key(key, "CTRL")
    send_key(key, "ALT")
    send_key(key, "SHIFT")
  end

  send_action(
    "PageUp",
    act.Multiple({
      tmux_prefix_send_key("PageUp"),
      activate_tmux_copy_mode(),
    })
  )
  send_key("PageDown")
  send_key("Backspace")
  send_physical_key("Delete")
  send_key("Escape")
  send_key("Enter")
  send_key("Tab")

  return keys
end

M.key_tables = {
  tmux_prefix = create_tmux_prefix_key_table(),
  tmux_copy_mode = create_tmux_copy_mode_key_table(),
  tmux_copy_prompt = create_tmux_copy_prompt_key_table(true),
  tmux_copy_prompt_once = create_tmux_copy_prompt_key_table(false),
}
```

并且需要在 `~/.config/wezterm/wezterm.lua` 启用：

```lua
key_tables = keybinds.key_tables,
```

### 生成式 key table 的工作方式

`create_tmux_prefix_key_table()` 不是手工写死每个 tmux 绑定，而是按键类型批量
生成转发表：

- `send_string()` 用 `act.SendString()` 发送字符本身。它覆盖 ASCII 可打印字符
  33-126 以及空格，所以 tmux 默认的 `z`、`[`、`]`、`:`、`?`、`"`、`%`、数字、
  pane/window 选择和大多数插件绑定都可以走这条路径。
- 对大写字母和标点额外注册 `mods = "SHIFT"`。有些键盘布局或键盘上报模式会把
  shifted punctuation / uppercase 作为带 `SHIFT` 的事件，上述规则可以兼容这类
  情况。
- `Ctrl+a` 到 `Ctrl+z` 被映射成对应控制字符，例如 `Ctrl+g` 会发送 `\x07`。
  这让 `Cmd+b Ctrl+g` 这种“发送 tmux prefix 本身”的操作仍然可用。
- `Alt+字母`、`Alt+数字` 和 `Alt+Shift+大写字母` 用 `act.SendKey()` 转发，
  保留修饰键语义。
- 方向键、`PageUp`、`PageDown`、`Backspace`、`Delete`、`Escape`、`Enter`、
  `Tab` 等非 printable 键也用 `act.SendKey()` 转发。

这张表的本质是“tmux prefix 后的一次输入转发层”。它不解析 tmux 配置，也不在
WezTerm 里实现 tmux 命令；tmux 收到 `C-g` 后仍然按自己的 prefix table 处理
下一枚键。

### copy-mode 持续转发表

`prefix + [` 的特殊之处在于它不是执行一个瞬时 tmux 命令，而是让 tmux 进入
copy-mode。进入 copy-mode 后，后续 `j/k/h/l`、`w/b/e`、`v/y`、`/`、`?` 等键
仍然需要持续绕过 Rime。

因此当前配置把 `[` 从普通 prefix 转发里单独拿出来：

```lua
local enter_tmux_copy_mode = act.Multiple({
  tmux_prefix_key("["),
  activate_tmux_copy_mode(),
})

send_action("[", enter_tmux_copy_mode)
send_action("[", enter_tmux_copy_mode, "SHIFT")
```

这会先把 `[` 发给 tmux，让 tmux 进入 copy-mode，然后用
`replace_current = true` 把一次性的 `tmux_prefix` key table 替换成持续的
`tmux_copy_mode` key table。

`tmux_copy_mode` 的规则和 prefix 表类似，也是生成式转发：

- 普通 ASCII 字符继续用 `SendString()`，所以 `j/k/h/l`、`w/b/e`、`g/G`、
  `v`、`Space` 等 vi copy-mode 操作可以在中文输入状态下直接生效。
- `Ctrl+c`、`Ctrl+j`、`q`、`y`、`Enter`、`A`、`D` 会先转发给 tmux，再
  `PopKeyTable`，因为这些按键通常会退出 copy-mode 或完成复制。
- `Escape` 只转发给 tmux，不退出 WezTerm 表；在 tmux vi copy-mode 中它默认
  是 `clear-selection`，不一定退出 copy-mode。
- `tmux_copy_mode` 有 10 分钟超时，避免通过鼠标或外部命令退出 copy-mode 后
  WezTerm 转发表长期残留。

copy-mode 里还有几类按键会进入 tmux 的 command-prompt：

- `/`、`?`、`:`、`1..9` 会激活 `tmux_copy_prompt`，持续转发搜索词、行号或
  repeat 参数，直到 `Enter`、`Escape` 或 `Ctrl+c`。
- `f/F/t/T` 会激活一次性的 `tmux_copy_prompt_once`，只转发 jump 目标字符。

这样可以避免在搜索 prompt 中输入 `q` 或 `y` 时误触发 copy-mode 退出规则。

## 行为和限制

这个方案已经验证可以解决中文状态下的常用 pane 跳转：

```text
Cmd+b h
Cmd+b j
Cmd+b k
Cmd+b l
```

同时也覆盖很多常见 prefix 命令，例如：

```text
Cmd+b c
Cmd+b %
Cmd+b "
Cmd+b [
Cmd+b :
Cmd+b ?
Cmd+b 0..9
Cmd+b Ctrl+g
Cmd+b Up/Down/Left/Right
```

进入 copy-mode 后，也可以在中文输入状态下直接使用：

```text
Cmd+b [ j/k/h/l
Cmd+b [ w/b/e
Cmd+b [ Space/v/y
Cmd+b [ /pattern
Cmd+b [ ?pattern
Cmd+b [ q
```

限制也很明确：

- 它不是完整 tmux 模拟，只是覆盖常见按键并转发给 tmux。
- 未覆盖的 prefix 后续键仍可能被 Rime 中文预编辑拦截。
- 如果新增的是普通 ASCII 字符、`Ctrl+字母`、常见 `Alt+字母/数字` 或方向键，
  通常不需要再改 WezTerm。
- 如果新增的是 `F1-F12`、`Home`、`End`、`Insert`、组合更复杂的特殊键，可能
  仍需要同步扩展 `create_tmux_prefix_key_table()`。
- 如果新增了自定义 copy-mode 绑定，并且该绑定会退出 copy-mode、进入
  command-prompt 或等待一个目标字符，需要同步扩展 `create_tmux_copy_mode_key_table()`。
- `Cmd+b` 已经先把 `C-g` 发给 tmux，所以 key table 里通常只需要发送后续键，
  不要再次发送完整 prefix 序列。

如果是带修饰键或特殊键，需要先确认 WezTerm 的 key 表示和 tmux 收到的按键是否
一致。

## 验证命令

确认 WezTerm 注册了生成式 `tmux_prefix` key table：

```sh
wezterm --config-file ~/.config/wezterm/wezterm.lua show-keys --lua |
  rg "tmux_prefix|tmux_copy_mode|tmux_copy_prompt|SendString 'h'|SendString 'j'|SendString 'k'|SendString 'l'|PopKeyTable"
```

应能看到类似：

```lua
{ key = 'b', mods = 'SUPER', action = act.Multiple{ ... ActivateKeyTable = { name = 'tmux_prefix' ... } } }
tmux_prefix = {
  { key = '[', mods = 'NONE', action = act.Multiple{ ... ActivateKeyTable = { name = 'tmux_copy_mode' ... } } },
  { key = 'g', mods = 'CTRL', action = act.SendString '\a' },
}
tmux_copy_mode = {
  { key = 'j', mods = 'NONE', action = act.SendString 'j' },
  { key = 'k', mods = 'NONE', action = act.SendString 'k' },
  { key = 'q', mods = 'NONE', action = act.Multiple{ ... 'PopKeyTable' } },
}
```

确认 tmux prefix 仍是 `C-g`：

```sh
tmux show-option -g prefix
tmux list-keys -T prefix | rg 'prefix\\s+[hjklLcfryxs]'
```

## 故障排查

如果转发方案失效：

1. 先确认 WezTerm 已重新加载配置，必要时重开窗口。
2. 用 `wezterm show-keys --lua` 确认 `Cmd+b` 包含 `ActivateKeyTable`。
3. 确认 `wezterm.lua` 没有再次注释掉 `key_tables = keybinds.key_tables`。
4. 确认目标 tmux 命令确实在 `tmux list-keys -T prefix` 中存在。
5. 如果只是不支持某个特殊 prefix 键，把该键加入
   `create_tmux_prefix_key_table()`。
6. 如果是进入 copy-mode 后的按键失效，检查 `tmux_copy_mode` 或
   `tmux_copy_prompt` 是否覆盖了该键。

不要重新引入 `osascript` 输入源切换回调。它会让 prefix 时序不稳定，可能导致
英文状态下的 tmux prefix 也失效。
