/**
 * Asset Model
 * 资产数据模型定义
 */

// Asset状态类型 - 使用string而非字面量类型（符合ArkTS规范）
export interface AssetStatusType {
  IN_USE: string;
  RETIRED: string;
  SOLD: string;
}

export const AssetStatus: AssetStatusType = {
  IN_USE: 'In Use',
  RETIRED: 'Retired',
  SOLD: 'Sold'
};

/**
 * 资产接口定义
 */
export interface Asset {
  id: string;                    // 唯一标识
  name: string;                  // 资产名称
  icon: string;                  // Emoji 图标
  imageUrl?: string;             // 可选图片 URL（dataURL格式）
  status: string;                // 资产状态 ('In Use' | 'Retired' | 'Sold')
  purchasePrice: number;         // 购入价格 (¥)
  purchaseDate: string;          // 购入日期 (YYYY-MM-DD)
  targetUsageDays: number;       // 目标使用天数
}

/**
 * 创建资产时的输入数据（不含ID）
 */
export interface AssetInput {
  name: string;
  icon: string;
  imageUrl?: string;
  status: string;
  purchasePrice: number;
  purchaseDate: string;
  targetUsageDays: number;
}
