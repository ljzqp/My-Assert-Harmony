# 快速开始指南

## 🚀 5分钟快速上手

### 步骤1：打开项目

1. 启动 **DevEco Studio**
2. 选择 `File` → `Open`
3. 导航到 `harmony_project` 目录并打开

### 步骤2：配置签名（仅首次需要）

1. 点击 `File` → `Project Structure`
2. 选择 `Signing Configs`
3. 勾选 `Automatically generate signature`
4. 或手动配置开发者证书

### 步骤3：选择运行目标

**方式A：使用模拟器**
1. 工具栏点击 `Device Manager`
2. 创建或启动一个HarmonyOS模拟器

**方式B：使用真机**
1. 手机开启开发者模式
2. USB连接到电脑
3. 授权调试权限

### 步骤4：运行应用

1. 点击工具栏绿色运行按钮 ▶️
2. 或按快捷键 `Shift + F10`
3. 等待编译和安装完成

### 步骤5：体验功能

✅ 查看示例资产数据
✅ 点击底部按钮添加新资产
✅ 填写表单并保存
✅ 查看汇总统计更新

---

## 📱 功能演示

### 资产列表页面

- 顶部显示总资产价值、日均成本、资产数量
- 网格展示所有资产卡片
- 每个卡片显示：图标/图片、名称、价格、使用进度
- 底部浮动按钮：添加新资产

### 新增资产页面

1. **选择图标**
   - 点击"or Select Icon"按钮
   - 从6个分类中选择emoji图标
   - 或上传自定义图片（待实现）

2. **填写信息**
   - 名称：如"iPhone 15 Pro Max"
   - 状态：在用/已退役/已出售
   - 购入价格：如9999
   - 购入日期：YYYY-MM-DD格式
   - 目标使用天数：如1095（3年）

3. **保存资产**
   - 点击"Save Asset"按钮
   - 自动返回列表页
   - 新资产显示在顶部

---

## 🐛 常见问题

### Q1: 编译报错怎么办？

**A:** 检查以下几点：
- HarmonyOS SDK版本 ≥ API 12
- DevEco Studio版本 ≥ 5.0
- 查看具体错误信息，确认文件路径正确

### Q2: 应用闪退怎么办？

**A:** 可能原因：
- 签名配置不正确
- 设备API版本过低
- 查看Logcat日志定位问题

### Q3: 数据丢失了？

**A:** 检查：
- 是否卸载重装了应用（会清空数据）
- 持久化服务是否正常初始化
- 查看AssetStorageService.ets的日志

### Q4: 样式显示不正确？

**A:** 确认：
- color.json资源文件是否正确加载
- 使用了$r('app.color.xxx')引用资源
- 检查ArkUI属性值是否正确

---

## 🔧 开发调试

### 查看日志

```bash
# 在DevEco Studio底部打开Logcat
# 过滤标签：AssetTracker
```

### 清除数据

```bash
# 卸载应用并重装
# 或在设置中清除应用数据
```

### 修改代码后

1. 保存文件（Ctrl+S / Cmd+S）
2. 重新运行应用
3. 或使用热重载（如果支持）

---

## 📚 项目结构说明

```
harmony_project/
├── entry/src/main/ets/          # ArkTS源代码
│   ├── pages/Index.ets          # 主页面（入口）
│   ├── components/              # UI组件
│   ├── models/                  # 数据模型
│   ├── utils/                   # 工具函数
│   └── services/                # 业务服务
├── resources/                   # 资源文件
│   └── base/element/
│       ├── color.json          # 颜色定义
│       └── string.json         # 字符串资源
└── module.json5                # 模块配置
```

### 关键文件说明

| 文件 | 作用 | 何时修改 |
|------|------|---------|
| `Index.ets` | 应用入口 | 修改主逻辑时 |
| `AssetListPage.ets` | 列表页 | 修改列表展示时 |
| `AddAssetPage.ets` | 新增页 | 修改表单时 |
| `color.json` | 颜色资源 | 更改配色时 |
| `Constants.ets` | 常量定义 | 更改示例数据、图标分类时 |

---

## 🎨 自定义配置

### 修改主题色

编辑 `resources/base/element/color.json`:

```json
{
  "name": "primary",
  "value": "#10B981"  // 改为你喜欢的颜色
}
```

### 修改示例数据

编辑 `constants/Constants.ets`:

```typescript
export const mockAssets: Asset[] = [
  {
    id: '1',
    name: '你的资产名称',
    icon: '🎯',
    // ...
  }
];
```

### 添加新的图标分类

编辑 `constants/Constants.ets`:

```typescript
export const ICON_CATEGORIES: IconCategory[] = [
  // ...现有分类
  {
    name: 'Food',
    icon: '🍔',
    items: ['🍕', '🍔', '🍟', '🌮', '🍜']
  }
];
```

---

## ✅ 下一步

- [ ] 熟悉项目结构
- [ ] 尝试添加自己的资产
- [ ] 查看汇总统计变化
- [ ] 阅读 MIGRATION_REPORT.md 了解改造细节
- [ ] 参考 Coding.md 学习ArkTS编码规范

---

## 💡 提示

- 数据会自动保存，刷新应用不会丢失
- 支持手机、平板、2in1设备
- 暂不支持横屏模式（可后续扩展）
- 建议在真机上测试以获得最佳体验

---

**遇到问题？** 请查看 README.md 或 MIGRATION_REPORT.md 文档
