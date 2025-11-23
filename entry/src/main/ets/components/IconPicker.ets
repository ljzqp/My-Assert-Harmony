/**
 * Icon Picker Component
 * 图标选择器组件（底部抽屉）
 */

import { IconCategory } from '../models/IconCategory';
import { ICON_CATEGORIES } from '../constants/Constants';

/**
 * 图标选择器组件
 */
@Component
export struct IconPicker {
  @Link isOpen: boolean;
  @Link selectedIcon: string;
  @State activeCategory: string = ICON_CATEGORIES[0].name;

  /**
   * 获取当前分类的图标列表
   */
  private getActiveItems(): string[] {
    let items: string[] = [];
    for (let i = 0; i < ICON_CATEGORIES.length; i++) {
      const category: IconCategory = ICON_CATEGORIES[i];
      if (category.name === this.activeCategory) {
        items = category.items;
        break;
      }
    }
    return items;
  }

  /**
   * 关闭选择器
   */
  private handleClose(): void {
    this.isOpen = false;
  }

  /**
   * 选择图标
   */
  private handleSelect(icon: string): void {
    this.selectedIcon = icon;
    this.isOpen = false;
  }

  build() {
    if (this.isOpen) {
      // 全屏遮罩层
      Stack() {
        // 半透明背景
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#99000000')
          .onClick(() => {
            this.handleClose();
          })

        // 底部抽屉
        Column() {
          // 标题
          Text('Select Asset Icon')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .margin({ bottom: 16 })

          // 分类横向滚动
          Scroll() {
            Row({ space: 8 }) {
              ForEach(
                ICON_CATEGORIES,
                (category: IconCategory) => {
                  Button() {
                    Row({ space: 4 }) {
                      Text(category.icon)
                        .fontSize(16)
                      Text(category.name)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                    }
                  }
                  .backgroundColor(
                    this.activeCategory === category.name
                      ? $r('app.color.primary')
                      : '#F1F5F9'
                  )
                  .fontColor(
                    this.activeCategory === category.name
                      ? Color.White
                      : $r('app.color.text_secondary')
                  )
                  .borderRadius(8)
                  .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                  .onClick(() => {
                    this.activeCategory = category.name;
                  })
                },
                (category: IconCategory) => category.name
              )
            }
            .padding({ left: 16, right: 16 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .width('100%')
          .margin({ bottom: 16 })

          // 图标网格
          Grid() {
            ForEach(
              this.getActiveItems(),
              (icon: string, index: number) => {
                GridItem() {
                  Button() {
                    Text(icon)
                      .fontSize(32)
                  }
                  .backgroundColor('#F1F5F9')
                  .borderRadius(8)
                  .width('100%')
                  .aspectRatio(1)
                  .onClick(() => {
                    this.handleSelect(icon);
                  })
                }
              },
              (icon: string, index: number) => `${this.activeCategory}_${index}`
            )
          }
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
          .rowsGap(16)
          .columnsGap(16)
          .height(200)
          .padding({ left: 16, right: 16 })
          .margin({ bottom: 16 })

          // 取消按钮
          Button('Cancel')
            .width('90%')
            .height(48)
            .backgroundColor('#F1F5F9')
            .fontColor($r('app.color.text_secondary'))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .borderRadius(12)
            .onClick(() => {
              this.handleClose();
            })
        }
        .width('100%')
        .backgroundColor($r('app.color.surface'))
        .borderRadius({ topLeft: 16, topRight: 16 })
        .padding({ top: 16, bottom: 24 })
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .alignContent(Alignment.Bottom)
    }
  }
}
