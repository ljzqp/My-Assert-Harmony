/**
 * Asset API Service
 * 资产管理 API 服务
 */

import { http } from '@kit.NetworkKit';

// API 基础地址
const API_BASE_URL = 'http://47.115.163.247:8081/api';

/**
 * 资产数据接口
 */
export interface AssetData {
  id: string;
  name: string;
  icon: string;
  imageUrl?: string;
  status: string;
  purchasePrice: number;
  purchaseDate: string;
  targetUsageDays: number;
  notes?: string;
}

/**
 * 创建/更新资产请求
 */
export interface AssetRequest {
  name: string;
  icon: string;
  imageUrl?: string;
  status: string;
  purchasePrice: number;
  purchaseDate: string;
  targetUsageDays: number;
  notes?: string;
}

/**
 * 分页响应
 */
export interface PageResponse {
  items: AssetData[];
  total: number;
  page: number;
  pageSize: number;
}

/**
 * 统计数据
 */
export interface AssetStats {
  totalCount: number;
  totalValue: number;
  inUseCount: number;
  retiredCount: number;
  soldCount: number;
}

/**
 * API 响应
 */
export interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
  timestamp: number;
}

/**
 * 查询参数
 */
export interface QueryParams {
  page?: number;
  pageSize?: number;
  status?: string;
  name?: string;
  purchaseDateStart?: string;
  purchaseDateEnd?: string;
  sortBy?: string;
  sortOrder?: string;
}

/**
 * 资产 API 服务类
 */
export class AssetApiService {
  /**
   * 分页查询资产
   */
  static async getAssets(params?: QueryParams): Promise<PageResponse> {
    const httpRequest = http.createHttp();

    // 构建查询字符串
    let queryString = '';
    if (params) {
      const queryParts: string[] = [];
      if (params.page) queryParts.push(`page=${params.page}`);
      if (params.pageSize) queryParts.push(`pageSize=${params.pageSize}`);
      if (params.status) queryParts.push(`status=${params.status}`);
      if (params.name) queryParts.push(`name=${encodeURIComponent(params.name)}`);
      if (params.purchaseDateStart) queryParts.push(`purchaseDateStart=${params.purchaseDateStart}`);
      if (params.purchaseDateEnd) queryParts.push(`purchaseDateEnd=${params.purchaseDateEnd}`);
      if (params.sortBy) queryParts.push(`sortBy=${params.sortBy}`);
      if (params.sortOrder) queryParts.push(`sortOrder=${params.sortOrder}`);
      if (queryParts.length > 0) {
        queryString = '?' + queryParts.join('&');
      }
    }

    const url = `${API_BASE_URL}/v1/assets${queryString}`;
    console.info(`AssetApiService: GET ${url}`);

    const response = await httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      },
      connectTimeout: 30000,
      readTimeout: 30000
    });

    httpRequest.destroy();

    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as ApiResponse<PageResponse>;
      if (result.code === 200) {
        return result.data;
      } else {
        throw new Error(result.message);
      }
    } else {
      throw new Error(`HTTP Error: ${response.responseCode}`);
    }
  }

  /**
   * 获取资产详情
   */
  static async getAssetById(id: string): Promise<AssetData> {
    const httpRequest = http.createHttp();

    const url = `${API_BASE_URL}/v1/assets/${id}`;
    console.info(`AssetApiService: GET ${url}`);

    const response = await httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      },
      connectTimeout: 30000,
      readTimeout: 30000
    });

    httpRequest.destroy();

    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as ApiResponse<AssetData>;
      if (result.code === 200) {
        return result.data;
      } else {
        throw new Error(result.message);
      }
    } else {
      throw new Error(`HTTP Error: ${response.responseCode}`);
    }
  }

  /**
   * 创建资产
   */
  static async createAsset(asset: AssetRequest): Promise<void> {
    const httpRequest = http.createHttp();

    const url = `${API_BASE_URL}/v1/assets`;
    console.info(`AssetApiService: POST ${url}`);

    const response = await httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json'
      },
      extraData: JSON.stringify(asset),
      connectTimeout: 30000,
      readTimeout: 30000
    });

    httpRequest.destroy();

    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as ApiResponse<null>;
      if (result.code !== 200) {
        throw new Error(result.message);
      }
    } else {
      throw new Error(`HTTP Error: ${response.responseCode}`);
    }
  }

  /**
   * 全量更新资产
   */
  static async updateAsset(id: string, asset: AssetRequest): Promise<void> {
    const httpRequest = http.createHttp();

    const url = `${API_BASE_URL}/v1/assets/${id}`;
    console.info(`AssetApiService: PUT ${url}`);

    const response = await httpRequest.request(url, {
      method: http.RequestMethod.PUT,
      header: {
        'Content-Type': 'application/json'
      },
      extraData: JSON.stringify(asset),
      connectTimeout: 30000,
      readTimeout: 30000
    });

    httpRequest.destroy();

    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as ApiResponse<null>;
      if (result.code !== 200) {
        throw new Error(result.message);
      }
    } else {
      throw new Error(`HTTP Error: ${response.responseCode}`);
    }
  }

  /**
   * 局部更新资产
   */
  static async patchAsset(id: string, updates: Partial<AssetRequest>): Promise<void> {
    const httpRequest = http.createHttp();

    const url = `${API_BASE_URL}/v1/assets/${id}`;
    console.info(`AssetApiService: PATCH ${url}`);

    const response = await httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      },
      extraData: JSON.stringify(updates),
      connectTimeout: 30000,
      readTimeout: 30000
    });

    httpRequest.destroy();

    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as ApiResponse<null>;
      if (result.code !== 200) {
        throw new Error(result.message);
      }
    } else {
      throw new Error(`HTTP Error: ${response.responseCode}`);
    }
  }

  /**
   * 删除资产
   */
  static async deleteAsset(id: string): Promise<void> {
    const httpRequest = http.createHttp();

    const url = `${API_BASE_URL}/v1/assets/${id}`;
    console.info(`AssetApiService: DELETE ${url}`);

    const response = await httpRequest.request(url, {
      method: http.RequestMethod.DELETE,
      header: {
        'Content-Type': 'application/json'
      },
      connectTimeout: 30000,
      readTimeout: 30000
    });

    httpRequest.destroy();

    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as ApiResponse<null>;
      if (result.code !== 200) {
        throw new Error(result.message);
      }
    } else {
      throw new Error(`HTTP Error: ${response.responseCode}`);
    }
  }

  /**
   * 获取资产统计
   */
  static async getStats(): Promise<AssetStats> {
    const httpRequest = http.createHttp();

    const url = `${API_BASE_URL}/v1/assets/stats`;
    console.info(`AssetApiService: GET ${url}`);

    const response = await httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      },
      connectTimeout: 30000,
      readTimeout: 30000
    });

    httpRequest.destroy();

    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as ApiResponse<AssetStats>;
      if (result.code === 200) {
        return result.data;
      } else {
        throw new Error(result.message);
      }
    } else {
      throw new Error(`HTTP Error: ${response.responseCode}`);
    }
  }
}
