/**
 * Format Utils
 * 格式化工具函数
 */

/**
 * 格式化货币数值
 * @param value 数值
 * @returns 格式化后的字符串（无小数位，带千位分隔符）
 */
export function formatCurrency(value: number): string {
  return value.toLocaleString('zh-CN', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  });
}

/**
 * 格式化日均成本
 * @param value 数值
 * @returns 格式化后的字符串（2位小数，带千位分隔符）
 */
export function formatDailyCost(value: number): string {
  return value.toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  });
}

/**
 * 生成唯一的资产ID
 * @returns 唯一ID字符串
 */
export function generateAssetId(): string {
  const timestamp: number = Date.now();
  const random: number = Math.random();
  return `asset_${timestamp}_${random}`;
}
