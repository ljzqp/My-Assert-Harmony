/**
 * Asset Storage Service
 * 资产数据持久化服务（使用AppStorage + PersistentStorage）
 */

import { Asset } from '../models/Asset';

/**
 * 资产存储服务类
 * 使用PersistentStorage进行数据持久化
 */
export class AssetStorageService {
  private static readonly KEY_ASSETS: string = 'assets_data';

  /**
   * 初始化持久化存储
   * 需要在应用启动时调用
   */
  static initStorage(): void {
    // 使用PersistentStorage持久化assets_data
    PersistentStorage.persistProp(AssetStorageService.KEY_ASSETS, '[]');
  }

  /**
   * 保存资产列表
   * @param assets 资产列表
   */
  static saveAssets(assets: Asset[]): void {
    try {
      const jsonString: string = JSON.stringify(assets);
      AppStorage.setOrCreate(AssetStorageService.KEY_ASSETS, jsonString);
    } catch (error) {
      console.error('Save assets failed:', error);
    }
  }

  /**
   * 加载资产列表
   * @returns 资产列表数组
   */
  static loadAssets(): Asset[] {
    try {
      const jsonString: string = AppStorage.get(AssetStorageService.KEY_ASSETS) as string;
      if (!jsonString || jsonString === '[]') {
        return [];
      }
      const assets: Asset[] = JSON.parse(jsonString) as Asset[];
      return assets;
    } catch (error) {
      console.error('Load assets failed:', error);
      return [];
    }
  }

  /**
   * 清空所有资产数据
   */
  static clearAssets(): void {
    AppStorage.setOrCreate(AssetStorageService.KEY_ASSETS, '[]');
  }
}
