/**
 * Summary Header Component
 * 资产汇总统计组件
 */

import { Asset } from '../models/Asset';
import { formatCurrency, formatDailyCost } from '../utils/FormatUtils';
import { calculateDaysUsed } from '../utils/DateUtils';
import { I18n } from '../services/I18nService';

/**
 * 汇总数据接口
 */
interface SummaryData {
  totalAssets: number;
  totalPurchaseAmount: number;
  totalDailyCost: number;
}

/**
 * 汇总统计组件
 */
@Component
export struct SummaryHeader {
  @Prop assets: Asset[] = [];

  /**
   * 计算汇总数据
   */
  private calculateSummary(): SummaryData {
    const totalAssets: number = this.assets.length;

    let totalPurchaseAmount: number = 0;
    for (let i = 0; i < this.assets.length; i++) {
      totalPurchaseAmount += this.assets[i].purchasePrice;
    }

    // 计算所有资产的日均成本总和
    // 每个资产的日均成本 = 购买价格 / 已使用天数
    let totalDailyCost: number = 0;
    for (let i = 0; i < this.assets.length; i++) {
      const asset: Asset = this.assets[i];
      const daysUsed = calculateDaysUsed(asset.purchaseDate);
      if (daysUsed > 0) {
        totalDailyCost += asset.purchasePrice / daysUsed;
      }
    }

    const summary: SummaryData = {
      totalAssets: totalAssets,
      totalPurchaseAmount: totalPurchaseAmount,
      totalDailyCost: totalDailyCost
    };

    return summary;
  }

  build() {
    Column() {
      // 总价值标签
      Text(I18n.t('label_total_value'))
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
        // 每日花费总和
        Column() {
          Text(I18n.t('label_daily_cost'))
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))

          Text(`¥${formatDailyCost(this.calculateSummary().totalDailyCost)}`)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.primary'))
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 资产数量
        Column() {
          Text(I18n.t('label_asset_count'))
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
