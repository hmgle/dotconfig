# dotconfig

This repository contains my Linux and OSX environment configurations. Primarily focused on Linux, it includes settings for zshrc, terminal emulation, keyboard mappings, tmux, and awesome WM.

目录约定：

- `home/`：直接安装到 `$HOME` 的 dotfiles
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

文档：

- [tmux 快捷键与插件速查](docs/tmux-shortcuts.md)
- [AwesomeWM 配置及快捷键指南](config/awesome/user-guide.md)
- [Rime 输入法定制说明](rime/README.md)
- [WezTerm 配置说明](config/wezterm/README.md)
- [GNOME Terminal 配置导入导出](system/linux/gnome-terminal/README.md)
- [TLP 电池充电策略配置](system/linux/tlp/README.md)

Feel free to adjust the content to better suit your preferences!
