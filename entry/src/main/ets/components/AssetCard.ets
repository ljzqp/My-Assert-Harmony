/**
 * Asset Card Component
 * 资产卡片组件
 */

import { Asset } from '../models/Asset';
import { calculateDaysUsed } from '../utils/DateUtils';
import { formatCurrency } from '../utils/FormatUtils';

/**
 * 状态颜色配置接口
 */
interface StatusColorConfig {
  backgroundColor: ResourceColor;
  textColor: ResourceColor;
}

/**
 * 资产卡片组件
 */
@Component
export struct AssetCard {
  @Prop asset: Asset = {
    id: '',
    name: '',
    icon: '',
    status: 'In Use',
    purchasePrice: 0,
    purchaseDate: '',
    targetUsageDays: 0
  };

  /**
   * 计算使用天数
   */
  private getDaysUsed(): number {
    return calculateDaysUsed(this.asset.purchaseDate);
  }

  /**
   * 计算使用进度（百分比）
   */
  private getProgress(): number {
    const daysUsed: number = this.getDaysUsed();
    const progress: number = (daysUsed / this.asset.targetUsageDays) * 100;
    return Math.min(progress, 100);
  }

  /**
   * 获取状态颜色配置
   */
  private getStatusColor(): StatusColorConfig {
    const config: StatusColorConfig = {
      backgroundColor: $r('app.color.status_in_use_bg'),
      textColor: $r('app.color.status_in_use_text')
    };

    if (this.asset.status === 'In Use') {
      config.backgroundColor = $r('app.color.status_in_use_bg');
      config.textColor = $r('app.color.status_in_use_text');
    } else if (this.asset.status === 'Retired') {
      config.backgroundColor = $r('app.color.status_retired_bg');
      config.textColor = $r('app.color.status_retired_text');
    } else if (this.asset.status === 'Sold') {
      config.backgroundColor = $r('app.color.status_sold_bg');
      config.textColor = $r('app.color.status_sold_text');
    }

    return config;
  }

  build() {
    Column() {
      // 图片/图标区域（带状态徽章）
      Stack() {
        // 图片或图标
        if (this.asset.imageUrl) {
          Image(this.asset.imageUrl)
            .width('100%')
            .aspectRatio(1)
            .borderRadius(16)
            .objectFit(ImageFit.Cover)
        } else {
          Column() {
            Text(this.asset.icon)
              .fontSize(48)
          }
          .width('100%')
          .aspectRatio(1)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F1F5F9')
          .borderRadius(16)
        }

        // 状态徽章（悬浮在左上角）
        Text(this.asset.status)
          .fontSize(10)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getStatusColor().textColor)
          .backgroundColor(this.getStatusColor().backgroundColor)
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .borderRadius(12)
          .margin({ top: 8, left: 8 })
      }
      .width('100%')
      .alignContent(Alignment.TopStart)

      // 资产信息区域
      Column() {
        // 名称和价格
        Column() {
          Text(this.asset.name)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(`¥${formatCurrency(this.asset.purchasePrice)}`)
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 2 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        // 使用进度
        Column() {
          // 使用天数标签
          Text(`${this.getDaysUsed()} days used`)
            .fontSize(10)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 4 })

          // 进度条
          Stack() {
            // 进度条背景
            Row()
              .width('100%')
              .height(6)
              .backgroundColor($r('app.color.progress_bar_bg'))
              .borderRadius(3)

            // 进度条前景
            Row()
              .width(`${this.getProgress()}%`)
              .height(6)
              .backgroundColor($r('app.color.primary'))
              .borderRadius(3)
          }
          .width('100%')
          .alignContent(Alignment.Start)
        }
        .width('100%')
        .margin({ top: 8 })
      }
      .width('100%')
      .padding(12)
    }
    .width('100%')
    .backgroundColor($r('app.color.surface'))
    .borderRadius(24)
    .shadow({
      radius: 8,
      color: '#10000000',
      offsetX: 0,
      offsetY: 2
    })
  }
}
