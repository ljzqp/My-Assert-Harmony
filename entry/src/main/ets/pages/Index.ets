/**
 * Index Page
 * 应用主页面 - 入口页面
 */

import { Asset, AssetInput } from '../models/Asset';
import { AssetApiService, AssetData, AssetRequest } from '../services/AssetApiService';
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
  @State isLoading: boolean = false;

  /**
   * 页面即将显示时（生命周期）
   */
  aboutToAppear(): void {
    // 加载资产数据
    this.loadAssets();
  }

  /**
   * 从 API 数据转换为本地 Asset 类型
   */
  private convertToAsset(data: AssetData): Asset {
    return {
      id: data.id,
      name: data.name,
      icon: data.icon,
      imageUrl: data.imageUrl,
      status: data.status,
      purchasePrice: data.purchasePrice,
      purchaseDate: data.purchaseDate,
      targetUsageDays: data.targetUsageDays
    };
  }

  /**
   * 加载资产数据
   */
  private async loadAssets(): Promise<void> {
    this.isLoading = true;
    try {
      const response = await AssetApiService.getAssets({
        page: 1,
        pageSize: 100,
        sortBy: 'purchaseDate',
        sortOrder: 'desc'
      });

      this.assets = response.items.map((item: AssetData) => this.convertToAsset(item));
      console.info(`Loaded ${this.assets.length} assets from API`);
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      console.error(`Failed to load assets: ${errorMsg}`);
      // 加载失败时显示空列表
      this.assets = [];
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 添加新资产
   */
  private handleAddAsset = async (newAsset: AssetInput): Promise<void> => {
    try {
      // 构建请求数据
      const request: AssetRequest = {
        name: newAsset.name,
        icon: newAsset.icon,
        imageUrl: newAsset.imageUrl,
        status: newAsset.status,
        purchasePrice: newAsset.purchasePrice,
        purchaseDate: newAsset.purchaseDate,
        targetUsageDays: newAsset.targetUsageDays
      };

      // 调用创建 API
      await AssetApiService.createAsset(request);
      console.info(`Asset created: ${newAsset.name}`);

      // 重新加载列表
      await this.loadAssets();

      // 返回列表页
      this.currentPage = 'list';
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      console.error(`Failed to create asset: ${errorMsg}`);
    }
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
