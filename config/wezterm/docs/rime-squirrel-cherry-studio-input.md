# Rime/Squirrel 与 Cherry Studio 输入问题排查记录

记录时间：2026-05-02

## 现象

macOS 下使用 Squirrel/Rime 时，WezTerm 中输入正常，但 Cherry Studio 等部分应用在 Rime 激活时无法输入。

最初表现为 Rime 中文状态下无法输入中文；后续在 Cherry Studio 中，Rime 中文状态和英文状态都无法输入任何内容。升级 Cherry Studio 后，输入恢复正常。

## 环境

- macOS：12.7.4
- Squirrel：0.16.2
- Cherry Studio：旧版存在问题，升级后恢复
- WezTerm：正常
- Rime 用户配置目录：`~/Library/Rime`

## 主要原因

主要问题在 Cherry Studio 旧版本的 Electron 输入法兼容层，而不是 WezTerm 配置直接影响其他应用。

排查过程中还发现几个会放大问题的配置因素：

- `select_character` Lua processor 配置写法不对，旧写法是 `lua_processor@select_character`，应改为 `lua_processor@*select_character`。
- 为了优化 WezTerm/tmux 曾经设置过全局 `style/inline_preedit: false`，这会影响其他应用，尤其是 Electron/Chromium 输入框。
- 当前使用的 `hmg` 主题内部也有 `inline_preedit: false`，会覆盖顶层设置。
- Cherry Studio 是 Electron 应用，实际输入可能涉及主进程和 Helper/Renderer 子进程，单独匹配主 bundle id 不一定足够。
- macOS 输入源状态曾出现不一致：`AppleSelectedInputSources` 选中了 Squirrel，但 `AppleEnabledInputSources` 中没有 Squirrel。

## 排查过程

1. 在 `~/Library/Rime/lua/select_character.lua` 临时加入日志，写入 `~/Library/Rime/rime-input-debug.log`。
2. 日志一度显示 Cherry Studio 中按键可以进入 Rime，说明不是 WezTerm 配置在全局拦截按键。
3. 当 Rime 能收到按键但应用不上屏时，问题更接近 Squirrel 与 Cherry Studio/Electron 的提交或预编辑桥接。
4. 检查 Squirrel 版本，发现本机是 `0.16.2`。
5. 查官方 release，`0.16.2` 之后正式版是 `0.18` 和 `1.x`；当前 Homebrew `squirrel-app 1.1.2` 要求 macOS 13+，本机 macOS 12.7.4 不能直接升级。
6. 检查 `squirrel.custom.yaml` 和 `build/squirrel.yaml`，确认全局和主题级 `inline_preedit` 最终值。
7. 检查 Cherry Studio bundle id，发现包括：
   - `com.kangfenmao.CherryStudio`
   - `com.kangfenmao.CherryStudio.helper`
   - `com.kangfenmao.CherryStudio.helper.Renderer`
   - `com.kangfenmao.CherryStudio.helper.GPU`
   - `com.kangfenmao.CherryStudio.helper.Plugin`
8. 修复 macOS 输入源启用列表，把 `im.rime.inputmethod.Squirrel.Hans` 补回 `AppleEnabledInputSources`。
9. 用户升级 Cherry Studio 后输入恢复，确认主要触发点是旧版 Cherry Studio/Electron 兼容问题。

## 保留的处理方法

### 修复 Lua processor 加载

在 `~/Library/Rime/rime_frost_double_pinyin_flypy.schema.yaml` 中保留：

```yaml
- lua_processor@*select_character
```

### 恢复全局 inline preedit

在 `~/Library/Rime/squirrel.custom.yaml` 中保留：

```yaml
patch:
  style/inline_preedit: true
```

当前使用的 `hmg` 主题内部也保留：

```yaml
hmg:
  inline_preedit: true
```

### WezTerm 单独使用 no_inline

WezTerm 继续单独保留：

```yaml
app_options:
  com.github.wez.wezterm:
    no_inline: true
```

### Cherry Studio 使用 inline

Cherry Studio 主进程和 Electron 子进程保留：

```yaml
app_options:
  com.kangfenmao.CherryStudio:
    inline: true
  com.kangfenmao.CherryStudio.helper:
    inline: true
  com.kangfenmao.CherryStudio.helper.Renderer:
    inline: true
  com.kangfenmao.CherryStudio.helper.GPU:
    inline: true
  com.kangfenmao.CherryStudio.helper.Plugin:
    inline: true
```

### 确认输入源启用状态

如果以后再次出现“状态栏显示 Squirrel/Rime，但应用里按键没有反应”，检查：

```sh
defaults read com.apple.HIToolbox AppleSelectedInputSources
defaults read com.apple.HIToolbox AppleEnabledInputSources
```

`AppleEnabledInputSources` 中应包含：

```text
Bundle ID = im.rime.inputmethod.Squirrel
Input Mode = im.rime.inputmethod.Squirrel.Hans
InputSourceKind = Input Mode
```

如缺失，可重新在系统设置的输入法列表中添加鼠须管，或手动修复后重启 `cfprefsd`。

## 清理内容

排查完成后已清理：

- `~/Library/Rime/lua/select_character.lua` 中的临时日志代码
- `~/Library/Rime/rime-input-debug.log`
- `/tmp/squirrel-pkg-check`
- 临时 Squirrel 旧诊断日志

保留的是实际配置修复项。

## 后续建议

- Cherry Studio 优先保持更新，因为本次最终恢复来自 Cherry Studio 升级。
- 当前 macOS 12.7.4 不适合直接通过 Homebrew 升级到 `squirrel-app 1.x`，因为新版要求 macOS 13+。
- 如果未来升级到 macOS 13+，可考虑升级 Squirrel 到新版本，再重新评估是否还需要 Cherry Studio 的 Helper/Renderer app options。
