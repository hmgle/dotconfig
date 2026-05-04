# macOS 下 zsh 新命令行自动切到 Rime 英文模式

## 背景

在 WezTerm 里使用 Squirrel/Rime 时，如果 Rime 停留在中文状态，新的 shell 命令
开头容易被当作拼音预编辑处理。大多数命令行的开头都应该是英文命令，例如：

```sh
cd ./目录示例
git status
nvim README.md
```

需要识别的状态不是“当前应用是 WezTerm”，而是“zsh 正在准备读取一条新命令”。
这个状态只有 zsh 的 ZLE 行编辑器知道，WezTerm 不能可靠判断当前编辑缓冲区是否为空。

## 当前方案

最终实现分成四层：

1. Squirrel 的 `app_options` 把 WezTerm 的默认 Rime 状态设为 `ascii_mode: true`。
2. 主输入方案给 `ascii_mode` 设置 `reset: 1`，并且不再把 `ascii_mode` 放进
   `switcher/save_options`，避免上次中文状态被持久记住。
3. zsh 通过 ZLE `line-init` hook 判断新命令行是否刚开始，并延迟触发切换。
4. hook 调用本地命令 `macos-reselect-squirrel`，短暂切到 ABC，再切回
   Squirrel.Hans，迫使 Squirrel 重新应用 WezTerm 的默认英文状态。

这个方案执行后最终仍停留在 `im.rime.inputmethod.Squirrel.Hans`，不是系统 ABC。
它不依赖 Quartz/CGEvent 模拟按键，因此不需要 macOS 辅助功能权限。

配置位置：

```text
~/.zshrc
~/Library/Rime/squirrel.custom.yaml
~/Library/Rime/default.custom.yaml
~/Library/Rime/rime_frost_double_pinyin_flypy.custom.yaml
~/Library/Rime/scripts/patch-wezterm-squirrel-build.zsh
~/.local/share/input-source-tools/macos-reselect-squirrel.swift
~/.local/bin/macos-reselect-squirrel
```

## Squirrel 配置

`~/Library/Rime/squirrel.custom.yaml`：

```yaml
patch:
  app_options:
    "com.github.wez.wezterm":
        ascii_mode: true
        vim_mode: true
        no_inline: true
```

部署命令：

```sh
"/Library/Input Methods/Squirrel.app/Contents/MacOS/rime_deployer" --build ~/Library/Rime
~/Library/Rime/scripts/patch-wezterm-squirrel-build.zsh
killall Squirrel 2>/dev/null || true
```

注意：在当前 Squirrel 0.16.2 配置编译结果里，WezTerm 的 `app_options` 出现过一个
和 kitty 不一致的问题：`squirrel.custom.yaml` 中写了 `ascii_mode: true`，但
`~/Library/Rime/build/squirrel.yaml` 里只剩 `no_inline: true`。kitty 可用而 WezTerm
不可用的直接原因就是 build 产物里 kitty 有 `ascii_mode`，WezTerm 没有。

因此部署后需要运行一次 build 补丁脚本，确保 build 产物包含：

```yaml
app_options:
  com.github.wez.wezterm:
    ascii_mode: true
    no_inline: true
    vim_mode: true
```

检查命令：

```sh
sed -n '10,18p' ~/Library/Rime/build/squirrel.yaml
```

## Rime 状态配置

`~/Library/Rime/default.custom.yaml` 里不要保存 `ascii_mode`：

```yaml
patch:
  switcher/save_options:
    - ascii_punct
    - traditionalization
    - emoji
    - full_shape
    - search_single_char
```

`~/Library/Rime/rime_frost_double_pinyin_flypy.custom.yaml`：

```yaml
patch:
  switches/@0/reset: 1
```

这两项解决的是另一个关键问题：`switcher/save_options` 原本保存了
`ascii_mode`，主 schema 的 `ascii_mode` 又没有 `reset`，所以“上次停在中文”会被
记忆。iTerm 的输入上下文重建能覆盖这个状态，而 kitty/WezTerm 的重选输入源路径不
一定覆盖，表现就是 iTerm 可用但 kitty/WezTerm 不可用。

WezTerm 的 bundle id 可验证为：

```sh
osascript -e 'id of app "WezTerm"'
```

应输出：

```text
com.github.wez.wezterm
```

## zsh 配置

`~/.zshrc` 中的关键配置：

```zsh
__zsh_schedule_rime_ascii_mode() {
  [[ -o interactive ]] || return 0
  [[ "$OSTYPE" == darwin* ]] || return 0
  (( $+commands[macos-reselect-squirrel] )) || return 0

  {
    sleep 0.18
    macos-reselect-squirrel >/dev/null 2>&1
  } &!
}

__zsh_line_init_set_rime_ascii_mode() {
  [[ "$CONTEXT" == start && -z "$BUFFER" ]] || return 0
  __zsh_schedule_rime_ascii_mode
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-init __zsh_line_init_set_rime_ascii_mode
```

这里刻意不依赖 `TERM_PROGRAM=WezTerm`。在 tmux pane 里，tmux 默认不会把
`TERM_PROGRAM` 放进 `update-environment`，所以以 WezTerm 环境变量作为条件会导致
hook 被跳过。

曾尝试在 `precmd` 同步切换输入源，但它发生在 prompt 显示之前，tmux 和部分终端会在
之后恢复旧输入上下文，导致肉眼看到“先切 ABC、再切回 Rime”，但 Rime 内部仍是中文。
当前方案只使用 ZLE `line-init`，并延迟 180ms 执行，使切换发生在 prompt 已显示、
终端文本输入上下文更稳定之后。

## macOS 工具

本地工具使用 Carbon Text Input Source API 和 AppKit 做三件事：

1. 选择 `com.apple.keylayout.ABC`。
2. 等待很短时间后选择 `im.rime.inputmethod.Squirrel.Hans`。
3. 重新激活调用时的前台应用，帮助 kitty/WezTerm 刷新输入上下文。

Squirrel 重新激活到 WezTerm 时，会读取 `app_options`，把 Rime 状态设为
`ascii_mode: true`。

当前工具里的关键时序：

```swift
let frontmostApp = NSWorkspace.shared.frontmostApplication
selectInputSource(abcID)
usleep(180_000)
selectInputSource(squirrelHansID)
usleep(60_000)
frontmostApp?.activate(options: [.activateIgnoringOtherApps])
```

这里的等待时间不是装饰性的。实际排查中能肉眼看到输入法图标先从 Rime 切到 ABC，
再从 ABC 切回 Rime；这只能说明系统输入源切换成功，不能说明当前终端的文本输入上下文
已经稳定接受了 Squirrel 的 `app_options`。如果切回太快，或者切换发生在 prompt 真正
可输入之前，Rime 仍可能保留中文状态。

编译命令：

```sh
swiftc ~/.local/share/input-source-tools/macos-reselect-squirrel.swift \
  -o ~/.local/bin/macos-reselect-squirrel
```

手动触发：

```sh
~/.local/bin/macos-reselect-squirrel
```

检查当前 macOS 输入源：

```sh
defaults read com.apple.HIToolbox AppleSelectedInputSources
```

成功后应仍看到：

```text
Bundle ID = im.rime.inputmethod.Squirrel
Input Mode = im.rime.inputmethod.Squirrel.Hans
```

## 尝试过但不采用的方案

### `precmd` 同步切换

最初在 zsh `precmd` 中同步调用输入源切换。它在非 tmux 的 WezTerm 中一度可用，但在
kitty 和 tmux 下不稳定。

观察到的现象：

- 输入法状态图标确实从 Rime 切到 ABC。
- 随后又切回 Rime。
- 但下一条命令开头仍然是 Rime 中文状态。

这说明输入源重选命令执行了，但执行时机太早。`precmd` 发生在 prompt 绘制之前；tmux
和部分终端会在 prompt 显示、pane 恢复可输入、输入法 client/context 重新建立时，把
旧的 Rime 中文状态带回来。最终看到的是系统输入源回到 Rime，但 Rime 内部没有应用
英文状态。

最终改为 ZLE `line-init` 后延迟 180ms 后执行：

```zsh
{
  sleep 0.18
  macos-reselect-squirrel >/dev/null 2>&1
} &!
```

这个时机更接近“prompt 已显示且 zsh 正在等待用户输入”，在 tmux 和非 tmux 下都更稳定。

### 只依赖 Squirrel `app_options`

iTerm 在非 tmux 和 tmux 下都可以，只靠 Squirrel 的 `app_options` 就能稳定回到英文。
kitty 和 WezTerm 不稳定，原因不是 bundle id 错，而是它们的输入上下文刷新行为和 iTerm
不同。iTerm 会更主动地重建/刷新输入法 client，使 `app_options` 覆盖保存状态；kitty
和 WezTerm 更容易保留旧的 Rime 会话状态。

因此最终方案同时处理三件事：

- `app_options` 声明终端默认英文。
- `ascii_mode reset: 1` 和移除 `save_options/ascii_mode`，避免中文状态被持久记忆。
- ZLE `line-init` 延迟重选 Squirrel，强制刷新当前输入上下文。

### 直接切到 ABC

旧方案使用 `macos-select-input-source com.apple.keylayout.ABC`，会把整个 macOS
输入源切到系统 ABC。它更简单，但不符合“保持 Squirrel/Rime，只切 Rime 英文模式”
的目标。

### 模拟 Rime 快捷键

另一个尝试是给 Rime 绑定：

```yaml
patch:
  key_binder/bindings/+:
    - { when: always, accept: "Control+Alt+Shift+F12", set_option: ascii_mode }
```

然后通过 CGEvent 发送 `Control+Option+Shift+F12`。这个方向理论上能直接改
`ascii_mode`，但需要 macOS 辅助功能权限，而且实际测试中独立 CLI 返回
`accessibility-trusted=false`，事件不能稳定到达 Squirrel/Rime。

相关文件仍保留，供以后排查：

```text
~/Library/Rime/default.custom.yaml
~/.local/share/input-source-tools/macos-rime-ascii-mode.swift
~/.local/bin/macos-rime-ascii-mode
```

## 验证

重新打开 WezTerm，或者在当前 pane 中执行：

```sh
exec zsh
```

把 Rime 手动切到中文状态，输入并执行：

```sh
echo 汉字
```

进入下一条命令行后，应仍然停留在 Squirrel 输入源，但 Rime 处于英文模式。

如果在 tmux 里验证，注意 tmux 的全局环境默认没有 `TERM_PROGRAM`：

```sh
tmux show-environment -g | rg 'TERM_PROGRAM|WEZTERM'
tmux show-options -g update-environment
```

当前方案不依赖这些变量，因此 tmux 内外都应该生效。

## 故障排查

如果以后又出现“能看到图标切换，但下一条命令仍是中文”，优先检查时序：

```zsh
sleep 0.18
```

可以逐步调大到 `0.25` 或 `0.35`。这类问题通常不是 Rime YAML 写错，而是终端/tmux
输入上下文还没有稳定。

检查 Rime build 产物：

```sh
sed -n '10,18p' ~/Library/Rime/build/squirrel.yaml
sed -n '124,134p' ~/Library/Rime/build/default.yaml
rg -n 'name: ascii_mode|reset: 1' ~/Library/Rime/build/rime_frost_double_pinyin_flypy.schema.yaml
```

应确认：

- WezTerm 条目包含 `ascii_mode: true`。
- `switcher/save_options` 不包含 `ascii_mode`。
- 主 schema 的 `ascii_mode` switch 有 `reset: 1`。

重新部署 Rime 后要补 WezTerm build 条目并重启 Squirrel：

```sh
"/Library/Input Methods/Squirrel.app/Contents/MacOS/rime_deployer" --build ~/Library/Rime
~/Library/Rime/scripts/patch-wezterm-squirrel-build.zsh
killall Squirrel 2>/dev/null || true
```

如果只在 tmux 中失败，确认当前 `.zshrc` 没有重新引入 `precmd` 切换逻辑。tmux 默认也
不会保留 `TERM_PROGRAM=WezTerm`，所以不要用这个变量作为 hook 是否启用的条件。
