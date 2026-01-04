# tmux 快捷键与插件速查

> 约定：`Prefix` 表示 `<kbd>Alt</kbd> + <kbd>b</kbd>`，这是 `tmux.conf` 中的新前缀键；`send-prefix` 仍可用 `<kbd>Alt</kbd> + <kbd>b</kbd>` 传递到嵌套 tmux。

## 会话 (Session)

### 自定义快捷键

- <kbd>Prefix</kbd> + <kbd>N</kbd>：新建 session。
- <kbd>Prefix</kbd> + <kbd>S</kbd>：列出所有 session 并切换（树形视图）。
- <kbd>Prefix</kbd> + <kbd>M</kbd>：通过 fzf 选择目标窗口，将当前 pane 移动过去。

### 默认快捷键

- <kbd>Prefix</kbd> + <kbd>$</kbd>：重命名当前 session。
- <kbd>Prefix</kbd> + <kbd>(</kbd> / <kbd>)</kbd>：切换到上一个/下一个 session。
- <kbd>Prefix</kbd> + <kbd>d</kbd>：从当前 session 分离 (detach)。
- <kbd>Prefix</kbd> + <kbd>D</kbd>：选择要分离的客户端。

> **注意**：默认的 `Prefix + s` 被 tmux-easymotion 覆盖，请用 `Prefix + S`（大写）切换 session。

## 窗口 (Window)

### 自定义快捷键

- <kbd>Prefix</kbd> + <kbd>c</kbd>：创建新窗口，目录继承当前 pane。
- <kbd>Prefix</kbd> + <kbd>L</kbd>：回到上一个访问的窗口。

### 默认快捷键

- <kbd>Prefix</kbd> + <kbd>0</kbd>-<kbd>9</kbd>：切换到编号 0-9 的窗口。
- <kbd>Prefix</kbd> + <kbd>n</kbd> / <kbd>p</kbd>：切换到下一个/上一个窗口。
- <kbd>Prefix</kbd> + <kbd>w</kbd>：列出所有窗口并选择切换。
- <kbd>Prefix</kbd> + <kbd>,</kbd>：重命名当前窗口。
- <kbd>Prefix</kbd> + <kbd>&</kbd>：关闭当前窗口（需确认）。
- <kbd>Prefix</kbd> + <kbd>.</kbd>：移动窗口到指定编号。

## 面板 (Pane)

### 自定义快捷键

- <kbd>Prefix</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd>：在左/下/上/右 pane 间移动，Vim 风格。
- <kbd>Prefix</kbd> + <kbd>"</kbd>：上下分屏，继承当前 pane 工作目录。
- <kbd>Prefix</kbd> + <kbd>%</kbd>：左右分屏，继承当前 pane 工作目录。
- <kbd>Prefix</kbd> + <kbd>t</kbd>：在当前目录打开 80%×75% 的 popup 终端。
- <kbd>Prefix</kbd> + <kbd>f</kbd>：通过 tmux-fzf 在 pane 间模糊切换。

### 默认快捷键

- <kbd>Prefix</kbd> + <kbd>o</kbd>：轮换到下一个 pane。
- <kbd>Prefix</kbd> + <kbd>;</kbd>：切换到上一个活动的 pane。
- <kbd>Prefix</kbd> + <kbd>q</kbd>：显示 pane 编号（可按数字快速切换，显示时长 8 秒）。
- <kbd>Prefix</kbd> + <kbd>x</kbd>：关闭当前 pane（需确认）。
- <kbd>Prefix</kbd> + <kbd>z</kbd>：最大化/还原当前 pane。
- <kbd>Prefix</kbd> + <kbd>{</kbd> / <kbd>}</kbd>：与上一个/下一个 pane 交换位置。
- <kbd>Prefix</kbd> + <kbd>!</kbd>：将当前 pane 拆分为独立窗口。
- <kbd>Prefix</kbd> + <kbd>Space</kbd>：循环切换 pane 布局。
- <kbd>Prefix</kbd> + <kbd>Ctrl</kbd>+<kbd>方向键</kbd>：微调 pane 大小。
- <kbd>Prefix</kbd> + <kbd>Alt</kbd>+<kbd>方向键</kbd>：大幅调整 pane 大小。

## 其他常用

- <kbd>Prefix</kbd> + <kbd>r</kbd>：重新加载 `~/.tmux.conf` 并提示 "Reloaded!"。
- <kbd>Prefix</kbd> + <kbd>?</kbd>：列出所有快捷键绑定。
- <kbd>Prefix</kbd> + <kbd>:</kbd>：进入命令模式。
- <kbd>Prefix</kbd> + <kbd>[</kbd>：进入复制模式。
- <kbd>Prefix</kbd> + <kbd>]</kbd>：粘贴最近复制的内容。

## 复制模式（vi）

进入方式：<kbd>Prefix</kbd> + <kbd>[</kbd>

### 自定义快捷键

- <kbd>v</kbd>：开启选择（类似 Vim visual mode）。
- <kbd>y</kbd>：复制选区到系统剪贴板（`xclip`）并退出复制模式。
- <kbd>c</kbd>：复制选区到系统剪贴板但停留在复制模式，按 <kbd>Enter</kbd> 后离开。

### 默认快捷键（vi 模式）

**导航：**

- <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd>：左/下/上/右移动。
- <kbd>w</kbd>/<kbd>b</kbd>/<kbd>e</kbd>：按单词前进/后退/词尾。
- <kbd>0</kbd>/<kbd>$</kbd>：行首/行尾。
- <kbd>g</kbd>/<kbd>G</kbd>：跳转到缓冲区开头/结尾。
- <kbd>Ctrl</kbd>+<kbd>u</kbd>/<kbd>Ctrl</kbd>+<kbd>d</kbd>：向上/向下翻半页。
- <kbd>Ctrl</kbd>+<kbd>b</kbd>/<kbd>Ctrl</kbd>+<kbd>f</kbd>：向上/向下翻整页。

**搜索：**

- <kbd>/</kbd>：向下搜索。
- <kbd>?</kbd>：向上搜索。
- <kbd>n</kbd>/<kbd>N</kbd>：下一个/上一个匹配。

**选择与复制：**

- <kbd>Space</kbd>：开始选择（默认）。
- <kbd>Enter</kbd>：复制选区并退出。
- <kbd>Esc</kbd>/<kbd>q</kbd>：退出复制模式。

## 配置说明

| 配置项               | 值             | 说明                        |
| -------------------- | -------------- | --------------------------- |
| `prefix`             | `Alt+b`        | 替代默认的 `Ctrl+b`         |
| `escape-time`        | 10ms           | 减少 Esc 延迟，Vim 用户友好 |
| `mode-keys`          | vi             | 复制模式使用 vi 键绑定      |
| `history-limit`      | 20000          | 滚动历史行数                |
| `display-panes-time` | 8000ms         | pane 编号显示时长           |
| `status-interval`    | 30s            | 状态栏刷新间隔              |
| `default-terminal`   | xterm-256color | 终端类型，支持真彩色        |

**窗口样式：**

- 非活动窗口：灰色前景 (`#808080`)，深色背景 (`#101010`)
- 活动窗口：终端默认颜色
- 活动 pane 边框：绿色

## 插件快捷键

### Tmux Plugin Manager (tpm)

- <kbd>Prefix</kbd> + <kbd>I</kbd>：安装/刷新所有插件。
- <kbd>Prefix</kbd> + <kbd>U</kbd>：更新全部插件。
- <kbd>Prefix</kbd> + <kbd>Alt</kbd> + <kbd>u</kbd>：卸载 `set -g @plugin` 列表中已移除的插件。

### tmux-fzf

- 默认 <kbd>Prefix</kbd> + <kbd>Shift</kbd>+<kbd>F</kbd> 启动主界面，可在会话/窗口/pane/命令/快捷键/剪贴板/进程间模糊搜索；支持 <kbd>TAB</kbd>/<kbd>Shift</kbd>+<kbd>TAB</kbd> 多选。
- 本配置额外提供：
  - <kbd>Prefix</kbd> + <kbd>f</kbd>：运行 `pane.sh switch`，弹出 FZF 在不同 pane 间切换。
  - <kbd>Prefix</kbd> + <kbd>y</kbd>：调用 `clipboard.sh`，以 FZF 浏览并复制剪贴板历史。
- 通过 `TMUX_FZF_OPTIONS="-p -w 86% -h 58% -m"` 和 `TMUX_FZF_PANE_FORMAT=...` 自定义弹窗尺寸与 pane 格式。

### tmux-fingers

- <kbd>Prefix</kbd> + <kbd>F</kbd>：进入 fingers 模式，高亮文件、SHA、IP、UUID 等并赋予提示字母。
- fingers 模式中：
  - <kbd>a</kbd>-<kbd>z</kbd>：复制所选匹配到系统剪贴板。
  - <kbd>Ctrl</kbd>/<kbd>Shift</kbd>/<kbd>Alt</kbd> + <kbd>a</kbd>-<kbd>z</kbd>：复制并分别触发 `:open:`、`:paste:`、用户自定义动作。
  - <kbd>TAB</kbd>：切换多选，第二次按下复制全部选中内容。
  - <kbd>q</kbd> / <kbd>Esc</kbd> / <kbd>Ctrl</kbd>+<kbd>c</kbd>：退出 fingers 模式。

### tmux-resurrect

- <kbd>Prefix</kbd> + <kbd>Ctrl</kbd> + <kbd>s</kbd>：手动保存当前 tmux 环境（会话/窗口/pane/工作目录/命令等）。
- <kbd>Prefix</kbd> + <kbd>Ctrl</kbd> + <kbd>r</kbd>：恢复最近一次保存的环境。

### tmux-continuum

- 依赖 tmux-resurrect，默认每 15 分钟在后台自动保存；配置中启用了 `@continuum-restore 'on'` 与 `@continuum-save-interval '60'`，即 60 分钟强制保存一次并在 tmux 启动时自动恢复。插件本身不额外增加快捷键。

### tmux-easymotion

- `@easymotion-key` 设为 `s`，因此默认 <kbd>Prefix</kbd> + <kbd>s</kbd> 触发 1 字符搜索：输入 1 个字符后，所有匹配位置会展示跳转标签，按标签字母即可将光标定位到对应位置（跨 pane 可用）。
- 可选地通过 `@easymotion-s2` 绑定 2 字符搜索（如 <kbd>Prefix</kbd> + <kbd>f</kbd>），但当前配置未启用；提示字母默认是 `asdghklqwertyuiopzxcvbnmfj;`。
