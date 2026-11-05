# dotconfig

This repository contains my Linux and OSX environment configurations. Primarily focused on Linux, it includes settings for zshrc, terminal emulation, keyboard mappings, tmux, and awesome WM.

目录约定：

- `home/`：直接安装到 `$HOME` 的 dotfiles，也可包含像 `~/.claude/`、`~/.codex/` 这样的家目录子树
- `config/`：安装到 `~/.config` 的配置
- `bin/`：个人脚本，安装时会接到 `~/bin`
- `system/`：需要手动处理或 `sudo` 安装的系统级配置
- `docs/`：说明文档

安装：

```bash
./install.sh
./install.sh --dry-run
./install.sh --skip-plugins --skip-system
```

Gestures 配置通过 `~/.config/gestures/gestures.kdl` 软链接到仓库中的
[`config/gestures/gestures.kdl`](config/gestures/gestures.kdl)，统一在仓库中维护。
三指拖拽结束后延迟 30ms（0.03 秒）释放鼠标按键；在此期间继续拖动可取消释放。
安装脚本会先备份已有配置，再创建软链接。

文档：

- [tmux 快捷键与插件速查](docs/tmux-shortcuts.md)
- [tmux 环境变量污染排查](docs/tmux-environment-trap.md)
- [AwesomeWM 配置及快捷键指南](config/awesome/user-guide.md)
- [Rime 输入法定制说明](rime/README.md)
- [WezTerm 配置说明](config/wezterm/README.md)
- [LXTerminal 配置说明](config/lxterminal/README.md)
- [GNOME Terminal 配置导入导出](system/linux/gnome-terminal/README.md)
- [TLP 电池充电策略配置](system/linux/tlp/README.md)

Feel free to adjust the content to better suit your preferences!
