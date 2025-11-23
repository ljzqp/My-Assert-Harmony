/**
 * Index Page
 * 应用主页面 - 入口页面
 */

import { Asset, AssetInput } from '../models/Asset';
import { mockAssets } from '../constants/Constants';
import { AssetStorageService } from '../services/AssetStorageService';
import { generateAssetId } from '../utils/FormatUtils';
import { AssetListPage } from '../components/AssetListPage';
import { AddAssetPage } from '../components/AddAssetPage';

/**
 * 应用主页面组件
 */
@Entry
@Component
struct Index {
  @State assets: Asset[] = [];
  @State currentPage: string = 'list'; // 'list' | 'add'

  /**
   * 页面即将显示时（生命周期）
   */
  aboutToAppear(): void {
    // 初始化持久化存储
    AssetStorageService.initStorage();

    // 加载资产数据
    this.loadAssets();
  }

  /**
   * 加载资产数据
   */
  private loadAssets(): void {
    const savedAssets: Asset[] = AssetStorageService.loadAssets();
    if (savedAssets.length > 0) {
      this.assets = savedAssets;
    } else {
      // 首次启动，使用示例数据
      this.assets = mockAssets;
      AssetStorageService.saveAssets(this.assets);
    }
  }

  /**
   * 添加新资产
   */
  private handleAddAsset = (newAsset: AssetInput): void => {
    // 生成唯一ID
    const assetWithId: Asset = {
      id: generateAssetId(),
      name: newAsset.name,
      icon: newAsset.icon,
      imageUrl: newAsset.imageUrl,
      status: newAsset.status,
      purchasePrice: newAsset.purchasePrice,
      purchaseDate: newAsset.purchaseDate,
      targetUsageDays: newAsset.targetUsageDays
    };

    // 头插入新资产
    this.assets = [assetWithId, ...this.assets];

    // 持久化保存
    AssetStorageService.saveAssets(this.assets);

    // 返回列表页
    this.currentPage = 'list';
  }

  build() {
    Column() {
      // 根据当前页面显示不同组件
      if (this.currentPage === 'list') {
        AssetListPage({
          assets: this.assets,
          currentPage: $currentPage
        })
      } else if (this.currentPage === 'add') {
        AddAssetPage({
          currentPage: $currentPage,
          onAddAsset: this.handleAddAsset
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }
}
