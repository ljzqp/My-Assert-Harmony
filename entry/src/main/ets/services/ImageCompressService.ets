/**
 * Image Compression Service
 * 图片压缩服务 - 使用鸿蒙原生 ImageKit
 */

import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';

/**
 * 压缩配置
 */
export interface CompressOptions {
  maxWidth?: number;      // 最大宽度，默认 1920
  maxHeight?: number;     // 最大高度，默认 1920
  quality?: number;       // 压缩质量 1-100，默认 80
}

/**
 * 图片压缩服务类
 */
export class ImageCompressService {
  /**
   * 压缩图片
   * @param sourcePath 源图片路径（支持 file:// 前缀）
   * @param destPath 目标图片路径
   * @param options 压缩配置
   * @returns 压缩后的文件路径
   */
  static async compressImage(
    sourcePath: string,
    destPath: string,
    options?: CompressOptions
  ): Promise<string> {
    const maxWidth = options?.maxWidth || 1920;
    const maxHeight = options?.maxHeight || 1920;
    const quality = options?.quality || 80;

    // 移除 file:// 前缀
    const actualSourcePath = sourcePath.startsWith('file://')
      ? sourcePath.substring(7)
      : sourcePath;

    console.info(`ImageCompressService: Compressing ${actualSourcePath}`);

    // 创建图片源
    const imageSource = image.createImageSource(actualSourcePath);
    const imageInfo = await imageSource.getImageInfo();

    console.info(`ImageCompressService: Original size ${imageInfo.size.width}x${imageInfo.size.height}`);

    // 计算缩放后的尺寸
    let targetWidth = imageInfo.size.width;
    let targetHeight = imageInfo.size.height;

    if (targetWidth > maxWidth || targetHeight > maxHeight) {
      const widthRatio = maxWidth / targetWidth;
      const heightRatio = maxHeight / targetHeight;
      const ratio = Math.min(widthRatio, heightRatio);

      targetWidth = Math.floor(targetWidth * ratio);
      targetHeight = Math.floor(targetHeight * ratio);
    }

    console.info(`ImageCompressService: Target size ${targetWidth}x${targetHeight}`);

    // 解码图片为 PixelMap
    const decodingOptions: image.DecodingOptions = {
      desiredSize: {
        width: targetWidth,
        height: targetHeight
      }
    };

    const pixelMap = await imageSource.createPixelMap(decodingOptions);

    // 创建图片打包器
    const imagePacker = image.createImagePacker();

    // 打包配置
    const packingOptions: image.PackingOption = {
      format: 'image/jpeg',
      quality: quality
    };

    // 打包为 ArrayBuffer
    const packedData = await imagePacker.packing(pixelMap, packingOptions);

    console.info(`ImageCompressService: Compressed size ${packedData.byteLength} bytes`);

    // 写入目标文件
    const destFile = fileIo.openSync(destPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
    fileIo.writeSync(destFile.fd, packedData);
    fileIo.closeSync(destFile);

    // 释放资源
    pixelMap.release();
    imagePacker.release();
    imageSource.release();

    console.info(`ImageCompressService: Saved to ${destPath}`);

    return destPath;
  }

  /**
   * 获取压缩后的文件名
   * @param originalPath 原始文件路径
   * @returns 压缩后的文件名
   */
  static getCompressedFileName(originalPath: string): string {
    const timestamp = Date.now();
    return `compressed_${timestamp}.jpg`;
  }
}
