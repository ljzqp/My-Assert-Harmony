/**
 * Summary Header Component
 * 资产汇总统计组件
 */

import { Asset } from '../models/Asset';
import { formatCurrency, formatDailyCost } from '../utils/FormatUtils';

/**
 * 汇总数据接口
 */
interface SummaryData {
  totalAssets: number;
  totalPurchaseAmount: number;
  avgDailyCost: number;
}

/**
 * 汇总统计组件
 */
@Component
export struct SummaryHeader {
  @Prop assets: Asset[] = [];

  /**
   * 计算汇总数据（替代React的useMemo）
   */
  private calculateSummary(): SummaryData {
    const totalAssets: number = this.assets.length;

    let totalPurchaseAmount: number = 0;
    for (let i = 0; i < this.assets.length; i++) {
      totalPurchaseAmount += this.assets[i].purchasePrice;
    }

    // 筛选在用资产
    const inUseAssets: Asset[] = [];
    for (let i = 0; i < this.assets.length; i++) {
      if (this.assets[i].status === 'In Use') {
        inUseAssets.push(this.assets[i]);
      }
    }

    // 计算总日均成本
    let totalDailyCost: number = 0;
    for (let i = 0; i < inUseAssets.length; i++) {
      const asset: Asset = inUseAssets[i];
      if (asset.targetUsageDays > 0) {
        totalDailyCost += asset.purchasePrice / asset.targetUsageDays;
      }
    }

    // 计算平均日均成本
    const avgDailyCost: number = inUseAssets.length > 0
      ? totalDailyCost / inUseAssets.length
      : 0;

    const summary: SummaryData = {
      totalAssets: totalAssets,
      totalPurchaseAmount: totalPurchaseAmount,
      avgDailyCost: avgDailyCost
    };

    return summary;
  }

  build() {
    Column() {
      // 总价值标签
      Text('Total Value')
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))

      // 总价值金额
      Text(`¥${formatCurrency(this.calculateSummary().totalPurchaseAmount)}`)
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 4 })

      // 统计指标网格
      Row() {
        // 日均成本
        Column() {
          Text('Avg Daily Cost')
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))

          Text(`¥${formatDailyCost(this.calculateSummary().avgDailyCost)}`)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.primary'))
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 资产数量
        Column() {
          Text('Total Assets')
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))

          Text(`${this.calculateSummary().totalAssets}`)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')
      .margin({ top: 24 })
    }
    .width('100%')
    .backgroundColor($r('app.color.surface'))
    .borderRadius(24)
    .padding(24)
    .shadow({
      radius: 8,
      color: '#10000000',
      offsetX: 0,
      offsetY: 2
    })
  }
}
