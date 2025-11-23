/**
 * Image Upload Service
 * 图片上传服务 - 处理贴纸生成
 */

import { http } from '@kit.NetworkKit';
import { fileIo } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';

// API 基础地址
const API_BASE_URL = 'http://47.115.163.247:8081';

/**
 * 贴纸处理响应数据
 */
export interface StickerProcessData {
  imageBase64: string;
  format: string;
  width: number | null;
  height: number | null;
}

export interface StickerProcessResponse {
  code: number;
  message: string;
  data: StickerProcessData;
}

/**
 * 图片上传服务类
 */
export class ImageUploadService {
  /**
   * 处理图片生成贴纸
   * @param imagePath 本地图片路径
   * @param outlineRadius 描边半径（默认12）
   * @param outlineColor 描边颜色（默认FFFFFF）
   * @returns 处理后的Base64图片数据
   */
  static async processStickerImage(
    imagePath: string,
    outlineRadius: number = 12,
    outlineColor: string = 'FFFFFF'
  ): Promise<string> {
    // 移除 file:// 前缀获取实际路径
    const actualPath = imagePath.startsWith('file://')
      ? imagePath.substring(7)
      : imagePath;

    // 读取图片文件
    const file = fileIo.openSync(actualPath, fileIo.OpenMode.READ_ONLY);
    const stat = fileIo.statSync(actualPath);
    const buffer = new ArrayBuffer(stat.size);
    fileIo.readSync(file.fd, buffer);
    fileIo.closeSync(file);

    // 将图片转换为Base64
    const base64Helper = new util.Base64Helper();
    const uint8Array = new Uint8Array(buffer);
    const imageBase64 = base64Helper.encodeToStringSync(uint8Array);

    // 生成boundary
    const boundary = `----WebKitFormBoundary${Date.now()}`;

    // 构建multipart/form-data请求体
    const fileName = actualPath.split('/').pop() || 'image.jpg';
    const mimeType = fileName.endsWith('.png') ? 'image/png' : 'image/jpeg';

    // 构建请求体各部分
    let bodyParts: string[] = [];

    // 文件部分 - 使用Base64编码的数据
    bodyParts.push(`--${boundary}`);
    bodyParts.push(`Content-Disposition: form-data; name="file"; filename="${fileName}"`);
    bodyParts.push(`Content-Type: ${mimeType}`);
    bodyParts.push('Content-Transfer-Encoding: base64');
    bodyParts.push('');
    bodyParts.push(imageBase64);

    // outline_radius 参数
    bodyParts.push(`--${boundary}`);
    bodyParts.push('Content-Disposition: form-data; name="outline_radius"');
    bodyParts.push('');
    bodyParts.push(outlineRadius.toString());

    // outline_color 参数
    bodyParts.push(`--${boundary}`);
    bodyParts.push('Content-Disposition: form-data; name="outline_color"');
    bodyParts.push('');
    bodyParts.push(outlineColor);

    // 结束boundary
    bodyParts.push(`--${boundary}--`);
    bodyParts.push('');

    const requestBody = bodyParts.join('\r\n');

    // 创建HTTP请求
    const httpRequest = http.createHttp();

    const response = await httpRequest.request(
      `${API_BASE_URL}/v1/sticker/process`,
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': `multipart/form-data; boundary=${boundary}`
        },
        extraData: requestBody,
        connectTimeout: 30000,
        readTimeout: 60000
      }
    );

    httpRequest.destroy();

    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as StickerProcessResponse;
      if (result.code === 200 && result.data && result.data.imageBase64) {
        return result.data.imageBase64;
      } else {
        throw new Error(result.message || 'Failed to process image');
      }
    } else {
      throw new Error(`HTTP Error: ${response.responseCode}`);
    }
  }

  /**
   * 将Base64图片保存到本地
   * @param base64Data Base64图片数据
   * @param filesDir 应用文件目录
   * @returns 保存后的文件路径
   */
  static saveBase64ToFile(base64Data: string, filesDir: string): string {
    const timestamp = Date.now();
    const fileName = `sticker_${timestamp}.png`;
    const filePath = `${filesDir}/${fileName}`;

    // 解码Base64
    const base64Helper = new util.Base64Helper();
    const uint8Array = base64Helper.decodeSync(base64Data);

    // 写入文件
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
    fileIo.writeSync(file.fd, uint8Array.buffer);
    fileIo.closeSync(file);

    return filePath;
  }
}
