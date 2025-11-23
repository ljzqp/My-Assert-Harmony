/**
 * Date Utils
 * 日期计算工具函数
 */

/**
 * 计算从购入日期到今天的使用天数
 * @param purchaseDate 购入日期 (YYYY-MM-DD格式)
 * @returns 使用天数（包含购入当天）
 */
export function calculateDaysUsed(purchaseDate: string): number {
  const purchase: Date = new Date(purchaseDate);
  const now: Date = new Date();

  // 使用UTC规范化日期，避免时区问题
  const start: number = Date.UTC(
    purchase.getFullYear(),
    purchase.getMonth(),
    purchase.getDate()
  );
  const end: number = Date.UTC(
    now.getFullYear(),
    now.getMonth(),
    now.getDate()
  );

  // 如果购入日期在未来，返回0
  if (start > end) {
    return 0;
  }

  const millisecondsPerDay: number = 1000 * 60 * 60 * 24;
  return Math.floor((end - start) / millisecondsPerDay) + 1; // 包含购入当天
}

/**
 * 格式化日期为 YYYY/MM/DD 格式（显示用）
 * @param dateStr 日期字符串 (YYYY-MM-DD)
 * @returns 格式化后的日期字符串 (YYYY/MM/DD)
 */
export function formatDateForDisplay(dateStr: string): string {
  return dateStr.replace(/-/g, '/');
}

/**
 * 格式化日期为 YYYY-MM-DD 格式（存储用）
 * @param dateStr 日期字符串 (YYYY/MM/DD)
 * @returns 格式化后的日期字符串 (YYYY-MM-DD)
 */
export function formatDateForStorage(dateStr: string): string {
  return dateStr.replace(/\//g, '-');
}

/**
 * 获取今天的日期字符串 (YYYY-MM-DD)
 * @returns 今天的日期字符串
 */
export function getTodayString(): string {
  const today: Date = new Date();
  const year: number = today.getFullYear();
  const month: number = today.getMonth() + 1;
  const day: number = today.getDate();

  const monthStr: string = month < 10 ? `0${month}` : `${month}`;
  const dayStr: string = day < 10 ? `0${day}` : `${day}`;

  return `${year}-${monthStr}-${dayStr}`;
}
