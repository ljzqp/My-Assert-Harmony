/**
 * Icon Category Model
 * 图标分类数据模型定义
 */

/**
 * 图标分类接口定义
 */
export interface IconCategory {
  name: string;                  // 分类名称
  icon: string;                  // 分类图标（emoji）
  items: string[];               // 该分类下的图标列表
}
