/**
 * Add Asset Page Component
 * 新增资产页面组件
 */

import { Asset, AssetInput } from '../models/Asset';
import { assetStatuses } from '../constants/Constants';
import { IconPicker } from './IconPicker';
import { getTodayString } from '../utils/DateUtils';
import { picker } from '@kit.CoreFileKit';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 新增资产页面组件
 */
@Component
export struct AddAssetPage {
  @Link currentPage: string;
  onAddAsset: (asset: AssetInput) => void = () => {};

  // 表单字段状态
  @State name: string = '';
  @State status: string = 'In Use';
  @State price: string = '';
  @State date: string = getTodayString();
  @State targetDays: string = '1095'; // 默认3年
  @State icon: string = '✨';
  @State imageUrl: string = '';
  @State isIconPickerOpen: boolean = false;

  /**
   * 表单校验：名称
   */
  private validateName(): string {
    if (this.name.trim().length === 0) {
      return 'Name is required';
    }
    return '';
  }

  /**
   * 表单校验：价格
   */
  private validatePrice(): string {
    const priceNum: number = parseFloat(this.price);
    if (isNaN(priceNum) || priceNum <= 0) {
      return 'Price must be > 0';
    }
    return '';
  }

  /**
   * 表单校验：日期
   */
  private validateDate(): string {
    if (this.date.trim().length === 0) {
      return 'Purchase date is required';
    }
    return '';
  }

  /**
   * 表单校验：目标天数
   */
  private validateTargetDays(): string {
    const days: number = parseInt(this.targetDays);
    if (isNaN(days) || days <= 0) {
      return 'Target days must be > 0';
    }
    return '';
  }

  /**
   * 表单校验：图标或图片
   */
  private validateIconOrImage(): string {
    if (this.icon.trim().length === 0 && this.imageUrl.trim().length === 0) {
      return 'Please select an icon or upload an image';
    }
    return '';
  }

  /**
   * 综合表单校验
   */
  private isFormValid(): boolean {
    return this.validateName() === '' &&
           this.validatePrice() === '' &&
           this.validateDate() === '' &&
           this.validateTargetDays() === '' &&
           this.validateIconOrImage() === '';
  }

  /**
   * 获取保存按钮背景色（根据表单有效性）
   */
  private getSaveButtonColor(): ResourceColor {
    return this.isFormValid()
      ? $r('app.color.primary')
      : $r('app.color.disabled_bg');
  }

  /**
   * 处理图标选择
   */
  private handleIconSelect(selectedIcon: string): void {
    this.icon = selectedIcon;
    this.imageUrl = ''; // 清空图片
  }

  /**
   * 从相册选择图片
   */
  private async pickImageFromGallery(): Promise<void> {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;

      const photoPicker = new picker.PhotoViewPicker();
      const result = await photoPicker.select(photoSelectOptions);

      if (result.photoUris && result.photoUris.length > 0) {
        const sourceUri = result.photoUris[0];

        // 获取应用上下文
        const context = getContext(this) as common.UIAbilityContext;
        const filesDir = context.filesDir;

        // 生成唯一文件名
        const timestamp = Date.now();
        const fileName = `asset_image_${timestamp}.jpg`;
        const destPath = `${filesDir}/${fileName}`;

        // 复制图片到应用沙箱目录
        const sourceFile = fileIo.openSync(sourceUri, fileIo.OpenMode.READ_ONLY);
        const destFile = fileIo.openSync(destPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);

        // 读取源文件并写入目标文件
        const bufferSize = 4096;
        const buffer = new ArrayBuffer(bufferSize);
        let readLen = fileIo.readSync(sourceFile.fd, buffer);
        while (readLen > 0) {
          fileIo.writeSync(destFile.fd, buffer, { length: readLen });
          readLen = fileIo.readSync(sourceFile.fd, buffer);
        }

        fileIo.closeSync(sourceFile);
        fileIo.closeSync(destFile);

        // 更新图片路径
        this.imageUrl = destPath;
        this.icon = ''; // 清空图标
      }
    } catch (error) {
      const err = error as BusinessError;
      console.error(`Failed to pick image: ${err.message}`);
    }
  }

  /**
   * 取消并返回列表页
   */
  private handleCancel(): void {
    this.currentPage = 'list';
  }

  /**
   * 提交表单
   */
  private handleSubmit(): void {
    // 短路返回：如果表单无效，直接返回
    if (!this.isFormValid()) {
      return;
    }

    const newAsset: AssetInput = {
      name: this.name,
      status: this.status,
      purchasePrice: parseFloat(this.price),
      purchaseDate: this.date,
      targetUsageDays: parseInt(this.targetDays),
      icon: this.icon,
      imageUrl: this.imageUrl.length > 0 ? this.imageUrl : undefined
    };

    this.onAddAsset(newAsset);
  }

  build() {
    Stack() {
      // 主内容区域
      Scroll() {
        Column() {
          // 页面标题栏
          Row() {
            Text('New Asset')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .layoutWeight(1)

            Button() {
              Text('×')
                .fontSize(28)
                .fontColor($r('app.color.text_secondary'))
            }
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.handleCancel();
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 32, bottom: 24 })

          // 表单区域
          Column({ space: 24 }) {
            // 图片/图标选择区域
            Row({ space: 16 }) {
              // 图片或图标预览
              Stack() {
                if (this.imageUrl.length > 0) {
                  Image(this.imageUrl)
                    .width(96)
                    .height(96)
                    .borderRadius(16)
                    .objectFit(ImageFit.Cover)
                } else {
                  Column() {
                    Text(this.icon)
                      .fontSize(48)
                  }
                  .width(96)
                  .height(96)
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor($r('app.color.surface'))
                  .borderRadius(16)
                }
              }

              // 按钮区域
              Column({ space: 8 }) {
                // 选择图片按钮
                Button('Select Photo')
                  .width('100%')
                  .height(40)
                  .backgroundColor($r('app.color.primary'))
                  .fontColor(Color.White)
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .borderRadius(8)
                  .onClick(() => {
                    this.pickImageFromGallery();
                  })

                // 选择图标按钮
                Button('or Select Icon')
                  .width('100%')
                  .height(40)
                  .backgroundColor($r('app.color.surface'))
                  .fontColor($r('app.color.text_primary'))
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .borderRadius(8)
                  .onClick(() => {
                    this.isIconPickerOpen = true;
                  })
              }
              .layoutWeight(1)
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)

            // 名称输入
            Column({ space: 8 }) {
              Text('Name')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.text_secondary'))

              TextInput({ placeholder: 'e.g., iPhone 15 Pro', text: this.name })
                .backgroundColor($r('app.color.surface'))
                .borderRadius(8)
                .padding(12)
                .onChange((value: string) => {
                  this.name = value;
                })

              // 错误提示
              if (this.validateName() !== '') {
                Text(this.validateName())
                  .fontSize(12)
                  .fontColor($r('app.color.error_text'))
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)

            // 状态选择
            Column({ space: 8 }) {
              Text('Status')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.text_secondary'))

              Row({ space: 8 }) {
                ForEach(
                  assetStatuses,
                  (statusOption: string) => {
                    Button(statusOption)
                      .layoutWeight(1)
                      .backgroundColor(
                        this.status === statusOption
                          ? $r('app.color.primary')
                          : $r('app.color.surface')
                      )
                      .fontColor(
                        this.status === statusOption
                          ? Color.White
                          : $r('app.color.text_primary')
                      )
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .borderRadius(8)
                      .onClick(() => {
                        this.status = statusOption;
                      })
                  },
                  (statusOption: string) => statusOption
                )
              }
              .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)

            // 价格和日期（2列）
            Row({ space: 16 }) {
              // 价格输入
              Column({ space: 8 }) {
                Text('Purchase Price (¥)')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.text_secondary'))

                TextInput({ placeholder: '9999', text: this.price })
                  .type(InputType.Number)
                  .backgroundColor($r('app.color.surface'))
                  .borderRadius(8)
                  .padding(12)
                  .onChange((value: string) => {
                    this.price = value;
                  })

                if (this.validatePrice() !== '') {
                  Text(this.validatePrice())
                    .fontSize(12)
                    .fontColor($r('app.color.error_text'))
                }
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              // 日期输入
              Column({ space: 8 }) {
                Text('Purchase Date')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.text_secondary'))

                TextInput({ placeholder: 'YYYY-MM-DD', text: this.date })
                  .backgroundColor($r('app.color.surface'))
                  .borderRadius(8)
                  .padding(12)
                  .onChange((value: string) => {
                    this.date = value;
                  })

                if (this.validateDate() !== '') {
                  Text(this.validateDate())
                    .fontSize(12)
                    .fontColor($r('app.color.error_text'))
                }
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')

            // 目标使用天数
            Column({ space: 8 }) {
              Text('Target Usage (days)')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.text_secondary'))

              TextInput({ placeholder: 'e.g., 1095 for 3 years', text: this.targetDays })
                .type(InputType.Number)
                .backgroundColor($r('app.color.surface'))
                .borderRadius(8)
                .padding(12)
                .onChange((value: string) => {
                  this.targetDays = value;
                })

              if (this.validateTargetDays() !== '') {
                Text(this.validateTargetDays())
                  .fontSize(12)
                  .fontColor($r('app.color.error_text'))
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 96 })
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Auto)

      // 底部保存按钮
      Column() {
        Button('Save Asset')
          .width('90%')
          .height(56)
          .backgroundColor(this.getSaveButtonColor())
          .fontColor(Color.White)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .borderRadius(28)
          .shadow({
            radius: 12,
            color: this.isFormValid() ? '#3010B981' : '#00000000',
            offsetX: 0,
            offsetY: 4
          })
          .onClick(() => {
            this.handleSubmit();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 24 })

      // 图标选择器
      IconPicker({
        isOpen: $isIconPickerOpen,
        selectedIcon: $icon
      })
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
  }
}
