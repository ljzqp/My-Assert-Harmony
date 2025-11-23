/**
 * Asset List Page Component
 * 资产列表页面组件
 */

import { Asset } from '../models/Asset';
import { SummaryHeader } from './SummaryHeader';
import { AssetCard } from './AssetCard';
import { I18n } from '../services/I18nService';

/**
 * 资产列表页面组件
 */
@Component
export struct AssetListPage {
  @Prop assets: Asset[] = [];
  @Link currentPage: string;

  /**
   * 导航到新增页面
   */
  private navigateToAdd(): void {
    this.currentPage = 'add';
  }

  build() {
    Stack() {
      // 主内容区域
      Scroll() {
        Column() {
          // 页面标题
          Column() {
            Text(I18n.t('page_title_my_assets'))
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .width('100%')

            Text(I18n.t('page_subtitle'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .width('100%')
              .margin({ top: 4 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding({ left: 16, right: 16, top: 32, bottom: 24 })

          // 汇总统计卡片
          SummaryHeader({ assets: this.assets })
            .margin({ left: 16, right: 16, bottom: 16 })

          // 资产网格
          if (this.assets.length > 0) {
            Grid() {
              ForEach(
                this.assets,
                (asset: Asset) => {
                  GridItem() {
                    AssetCard({ asset: asset })
                  }
                },
                (asset: Asset) => asset.id
              )
            }
            .columnsTemplate('1fr 1fr')
            .rowsGap(16)
            .columnsGap(16)
            .padding({ left: 16, right: 16, bottom: 96 })
          } else {
            // 空状态提示
            Column() {
              Text(I18n.t('empty_no_assets'))
                .fontSize(16)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 32, bottom: 8 })

              Text(I18n.t('empty_add_first'))
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
            }
            .width('100%')
            .padding({ top: 48, bottom: 96 })
          }
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Auto)

      // 浮动添加按钮
      Column() {
        Button() {
          Row({ space: 8 }) {
            Text('+')
              .fontSize(24)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)

            Text(I18n.t('btn_add_new_asset'))
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
          }
        }
        .width('90%')
        .height(56)
        .backgroundColor($r('app.color.primary'))
        .borderRadius(28)
        .shadow({
          radius: 12,
          color: '#3010B981',
          offsetX: 0,
          offsetY: 4
        })
        .onClick(() => {
          this.navigateToAdd();
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 24 })
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
  }
}
