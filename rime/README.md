# Rime 输入法配置

基于 [白霜拼音](https://github.com/gaboolic/rime-frost) 的个人定制配置。

## 包含的自定义配置

- **default.custom.yaml**: 自定义按键绑定（Ctrl+Alt+Shift+F12 强制英文模式）
- **squirrel.custom.yaml**: macOS 主题配置（hmg 配色方案）
- **custom_phrase.txt**: 个人短语和常用词

## 安装步骤

### 1. 安装白霜拼音基础配置

```bash
# 克隆上游仓库
git clone https://github.com/gaboolic/rime-frost.git /tmp/rime-frost

# 进入目录
cd /tmp/rime-frost

# 部署基础配置
rime_deployer --build
```

### 2. 复制自定义配置

#### Linux (fcitx5)

```bash
# 复制配置
cp default.custom.yaml ~/.local/share/fcitx5/rime/
cp custom_phrase.txt ~/.local/share/fcitx5/rime/

# 重新部署
rime_deployer --build ~/.local/share/fcitx5/rime
```

### 3. 验证安装

1. 在输入法设置中选择方案：`rime_frost_double_pinyin_flypy`
2. 重新部署
3. 测试自定义按键：`Ctrl+Alt+Shift+F12` 应切换到英文模式
4. 检查主题是否应用（macOS）

## 自定义配置说明

### default.custom.yaml

- 添加了极冷僻的组合键 `Ctrl+Alt+Shift+F12` 来强制切换到英文模式（我的 nvim 配置依赖这个组合键：https://github.com/hmgle/nvim/blob/25117377e3f9f398e6a3be41c910315e67f4ae52/lua/options.lua#L49）
- 避免与其他软件快捷键冲突

### squirrel.custom.yaml (macOS)

- 主题：hmg（浅色和深色都使用此主题）
- 水平排版候选词
- 自定义字体和颜色方案

### custom_phrase.txt

- 自定义短语和权重
- 常用技术词汇（go, golang, todo, amazon 等）
- 中文字词权重调整

## 注意事项

⚠️ **重要**：此仓库仅包含自定义配置，不包含词库文件。词库文件需要从上游获取。

## 更新配置

```bash
# 更新自定义配置
git pull

# 重新部署
rime_deployer --build ~/.local/share/fcitx5/rime
```

## 相关链接

- [白霜拼音官方仓库](https://github.com/gaboolic/rime-frost)
- [Rime 输入法官网](https://rime.im/)
- [鼠须管 (macOS)](https://github.com/rime/squirrel)
- [小狼毫 (Windows)](https://github.com/rime/weasel)
- [fcitx5-rime (Linux)](https://github.com/fcitx/fcitx5-rime)
