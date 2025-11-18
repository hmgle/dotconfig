# tmux 快捷键与插件速查

> 约定：`Prefix` 表示 `<kbd>Alt</kbd> + <kbd>b</kbd>`，这是 `tmux.conf` 中的新前缀键；`send-prefix` 仍可用 `<kbd>Alt</kbd> + <kbd>b</kbd>` 传递到嵌套 tmux。

## 会话、窗口与面板

- <kbd>Prefix</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd>：在左右/上下 pane 间移动，保持 Vim 手感。
- <kbd>Prefix</kbd> + <kbd>L</kbd>：回到上一个访问的窗口。
- <kbd>Prefix</kbd> + <kbd>"</kbd> / <kbd>Prefix</kbd> + <kbd>%</kbd>：分别进行上下或左右分屏，并继承当前 pane 的工作目录。
- <kbd>Prefix</kbd> + <kbd>c</kbd>：创建新窗口，目录继承当前 pane。
- <kbd>Prefix</kbd> + <kbd>t</kbd>：在当前 pane 目录中打开 80%×75% 的 popup，用于快速运行命令。
- <kbd>Prefix</kbd> + <kbd>r</kbd>：重新加载 `~/.tmux.conf` 并提示 “Reloaded!”。

## 复制模式（vi）

- `mode-keys` 设为 vi，进入复制模式后可直接使用 Vim 式导航。
- <kbd>v</kbd>：`copy-mode-vi` 中开启选择。
- <kbd>y</kbd>：复制选区到系统剪贴板（`xclip`）并退出复制模式。
- <kbd>c</kbd>：复制选区到系统剪贴板但停留在复制模式，按 <kbd>Enter</kbd> 后离开。

## 其他内置设定

- `history-limit` 提升至 20000，滚动历史更长。
- `display-panes-time` 设为 8000 ms，pane 编号提示显示更久。
- 状态栏保持黑底/白字，左侧显示 Session/Window/Pane。

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
