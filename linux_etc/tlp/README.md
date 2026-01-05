# TLP 电池充电策略配置

TLP 是 Linux 下的高级电源管理工具，可设置电池充电阈值以延长电池寿命。

## 当前配置

| 参数                     | 值  | 说明                    |
| ------------------------ | --- | ----------------------- |
| START_CHARGE_THRESH_BAT0 | 40  | 电量低于 40% 时开始充电 |
| STOP_CHARGE_THRESH_BAT0  | 70  | 电量达到 70% 时停止充电 |

## 安装 TLP

```bash
# Debian/Ubuntu
sudo apt install tlp tlp-rdw

# Arch Linux
sudo pacman -S tlp

# 启用服务
sudo systemctl enable tlp
sudo systemctl start tlp
```

## 配置方法

编辑 `/etc/tlp.conf`，添加或修改充电阈值：

```bash
sudo nano /etc/tlp.conf
```

修改后重新加载：

```bash
sudo tlp start
```

## 常用命令

```bash
# 查看电池状态和当前阈值
sudo tlp-stat -b

# 临时充满电池（忽略阈值限制）
sudo tlp fullcharge BAT0

# 恢复阈值设置
sudo tlp setcharge 40 70 BAT0

# 查看 TLP 运行状态
sudo tlp-stat -s
```

## 阈值选择建议

| 使用场景     | START | STOP | 说明           |
| ------------ | ----- | ---- | -------------- |
| 长期插电办公 | 40    | 70   | 最佳电池保护   |
| 偶尔移动使用 | 75    | 90   | 平衡续航与寿命 |
| 需要满电     | 95    | 100  | 最大续航       |

## 参考

- [TLP 官方文档](https://linrunner.de/tlp/)
- [电池阈值设置详解](https://linrunner.de/tlp/settings/battery.html)
- [各厂商支持情况](https://linrunner.de/tlp/settings/bc-vendors.html)
