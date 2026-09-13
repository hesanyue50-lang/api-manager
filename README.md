# API 管理助手

> 📥 **[点击下载 APK](https://github.com/hesanyue50-lang/api-manager/raw/main/com.minis.balancewidget.apk)**

Android 应用 + 桌面小组件，一站式管理各家 AI 平台的 API 余额。

## 功能

- **余额查询**：支持 DeepSeek、OpenRouter、阿里云百炼等 15+ 平台
- **桌面小组件**：主屏直接查看余额，自动刷新
- **多 Key 管理**：同一平台可添加多个 Key，区分主力/备用/项目
- **低余额预警**：设置阈值，跌破时推送通知
- **官网快捷入口**：一键跳转控制台或充值页
- **自定义平台**：支持任意 OpenAI 兼容接口
- **纯代码查询**：不调用任何 AI 接口，不消耗 token

## 支持平台

| 平台 | 币种 |
|---|---|
| DeepSeek | CNY |
| OpenRouter | USD |
| 阿里云百炼 | 预付费资源包 |
| 七牛云 AI | 后付费账单 |
| 硅基流动 | CNY |
| 月之暗面 | CNY |
| 智谱 AI | CNY |
| 火山方舟 | CNY |
| 讯飞星火 | CNY |
| 书生 InternLM | CNY |
| 阶跃星辰 | CNY |
| 优云智算 | CNY |
| Novita AI | USD |
| Fireworks AI | USD |
| 魔搭 ModelScope | 免费展示 |

## 安装

1. 下载上方 APK 链接
2. 手机允许「安装未知来源应用」
3. 安装后打开，按提示添加桌面小组件

## 隐私

- API Key 仅存本机，不上传
- 只向各平台官方接口发送查询请求
- 不调用任何 AI 接口，不消耗 token

<details>
<summary><strong>开发者详阅</strong>（点击展开）</summary>

## 构建

```bash
sh build.sh
```

产出 `com.minis.balancewidget.apk`。

## 小组件外观

设置页可选三种皮肤：

| 风格 | 观感 | 适用场景 |
|---|---|---|
| **玻璃**（默认） | 半透明深色面板 + 顶部高光 | 配系统桌面组件，壁纸会透出来 |
| 新拟物 | 不透明同色 + 浮雕阴影 | 想要立体质感 |
| 简约 | 不透明纯色 + 细边框 | 追求清晰 |

## 已知限制

- 小组件尺寸由桌面决定，可能无法显示全部平台
- 小组件玻璃/简约皮为半透明，壁纸太亮时对比度会下降
- 换风格需点「保存并刷新」

## 文件结构

| 文件 | 作用 |
|---|---|
| `src/.../BalanceFetcher.java` | 平台余额抓取与解析 |
| `src/.../BalanceWidgetProvider.java` | 小组件逻辑 |
| `src/.../MainActivity.java` | 主界面 |
| `src/.../SettingsActivity.java` | 设置界面 |
| `tools/gen_assets.py` | 9-patch 资源生成脚本 |
| `build.sh` | 构建脚本 |

</details>
