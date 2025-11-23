# Asset Tracker - HarmonyOS版本

一个优雅的个人资产管理应用，帮助您从长期视角追踪物品价值。

## 项目简介

Asset Tracker是一个轻量级的资产管理工具，专注于：
- 📊 追踪购入价格和使用时长
- 💰 计算日均成本，提供价值洞察
- 📱 移动优先设计，简洁易用
- 💾 本地数据持久化，隐私安全

## 技术栈

- **平台**: HarmonyOS 6.0+
- **语言**: ArkTS
- **UI框架**: ArkUI
- **数据持久化**: PersistentStorage + AppStorage

## 项目结构

```
harmony_project/
├── entry/src/main/
│   ├── ets/
│   │   ├── entryability/
│   │   │   └── EntryAbility.ets          # 应用入口
│   │   ├── pages/
│   │   │   └── Index.ets                 # 主页面
│   │   ├── components/                   # UI组件
│   │   │   ├── AssetListPage.ets         # 资产列表页
│   │   │   ├── AddAssetPage.ets          # 新增资产页
│   │   │   ├── SummaryHeader.ets         # 汇总统计
│   │   │   ├── AssetCard.ets             # 资产卡片
│   │   │   └── IconPicker.ets            # 图标选择器
│   │   ├── models/                       # 数据模型
│   │   │   ├── Asset.ets                 # 资产模型
│   │   │   └── IconCategory.ets          # 图标分类模型
│   │   ├── constants/                    # 常量定义
│   │   │   └── Constants.ets             # 图标、示例数据
│   │   ├── utils/                        # 工具函数
│   │   │   ├── DateUtils.ets             # 日期计算
│   │   │   └── FormatUtils.ets           # 格式化工具
│   │   └── services/                     # 业务服务
│   │       └── AssetStorageService.ets   # 数据持久化
│   └── resources/                        # 资源文件
│       └── base/
│           └── element/
│               ├── color.json            # 颜色资源
│               └── string.json           # 字符串资源
└── AppScope/
    └── app.json5                         # 应用配置
```

## 核心功能

### 1. 资产列表
- 2列网格展示所有资产
- 卡片显示：图标/图片、名称、价格、使用进度
- 状态徽章：在用/已退役/已出售
- 顶部汇总：总价值、日均成本、资产数量

### 2. 新增资产
- 表单字段：
  - 名称（必填）
  - 状态（在用/已退役/已出售）
  - 购入价格（必填，>0）
  - 购入日期（必填，YYYY-MM-DD格式）
  - 目标使用天数（必填，>0）
  - 图标或图片（二选一）
- 实时表单校验，英文错误提示
- 图标选择器：6个分类，36个emoji

### 3. 数据统计
- **总资产价值**: 所有资产购入价格总和
- **日均成本**: 在用资产的平均每日成本
- **资产数量**: 总资产数
- **使用进度**: 每个资产的使用天数和进度条

### 4. 数据持久化
- 使用PersistentStorage持久化存储
- 刷新应用数据不丢失
- 首次启动加载示例数据

## 代码规范

本项目严格遵循HarmonyOS ArkTS编码规范（详见Coding.md）：

✅ **类型系统**
- 使用`interface`，禁用`type`对象字面量
- 禁用`Record<K, V>`，使用显式interface
- 禁用`any`/`unknown`，使用具体类型

✅ **组件通信**
- 不传递函数作为`@Prop`
- 使用`@Link`双向绑定状态
- 使用方法引用传递回调

✅ **表单校验**
- 校验逻辑封装为方法
- 返回英文错误提示字符串
- UI中直接调用方法显示错误

✅ **UI规范**
- 不在`build()`内声明变量
- 计算逻辑封装为方法
- 使用正确的布局对齐枚举值

## 编译运行

### 环境要求
- DevEco Studio 5.0+
- HarmonyOS SDK API 12+
- 手机/平板/2in1设备

### 运行步骤

1. 使用DevEco Studio打开项目
```bash
# 打开harmony_project目录
```

2. 配置签名（首次运行需要）
   - 工具栏 > File > Project Structure > Signing Configs
   - 配置开发者证书

3. 连接设备或启动模拟器

4. 点击运行按钮（或按Shift+F10）

## 数据模型

### Asset（资产）

```typescript
interface Asset {
  id: string;                    // 唯一标识
  name: string;                  // 资产名称
  icon: string;                  // Emoji图标
  imageUrl?: string;             // 图片URL（可选）
  status: string;                // 状态：'In Use' | 'Retired' | 'Sold'
  purchasePrice: number;         // 购入价格（¥）
  purchaseDate: string;          // 购入日期（YYYY-MM-DD）
  targetUsageDays: number;       // 目标使用天数
}
```

## 核心算法

### 使用天数计算
```typescript
calculateDaysUsed(purchaseDate: string): number
// 从购入日期到今天的天数（包含购入当天）
// 使用UTC规范化，避免时区问题
```

### 使用进度计算
```typescript
progress = min((daysUsed / targetUsageDays) * 100, 100)
```

### 日均成本计算
```typescript
avgDailyCost = sum(price / targetDays for assets in use) / count(in use assets)
```

## 从React版本迁移

本项目是从React版本完全改造而来，主要转换包括：

| React | ArkTS | 说明 |
|-------|-------|------|
| `useState` | `@State` | 组件状态 |
| `useCallback` | 箭头函数方法 | 事件处理 |
| `useMemo` | 计算方法 | 衍生数据 |
| `props.onXxx()` | `@Link` | 状态双向绑定 |
| `className` | ArkUI属性 | 样式系统 |
| `array.map()` | `ForEach()` | 列表渲染 |
| TailwindCSS | ArkUI布局 | 样式方案 |

## 后续优化方向

- [ ] 资产编辑功能
- [ ] 资产删除功能
- [ ] 数据导出（JSON/CSV）
- [ ] 图表统计视图
- [ ] 多语言支持（i18n）
- [ ] 暗黑模式
- [ ] 云同步功能
- [ ] 桌面Widget小组件

## 许可证

本项目基于原React版本改造，保留原始许可证。

---

**开发者**: Aesthete Team
**版本**: 1.0.0
**最后更新**: 2025-11-17
