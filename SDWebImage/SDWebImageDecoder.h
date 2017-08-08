/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) james <https://github.com/mystcolor>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCoder.h"
#import "UIImage+ForceDecode.h"

@interface SDWebImageDecoder : NSObject <SDWebImageCoder>

+ (nonnull instancetype)sharedCoder;
- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data format:(SDImageFormat)format;
- (nullable UIImage *)incrementalDecodedImageWithData:(nullable NSData *)data format:(SDImageFormat)format finished:(BOOL)finished;
- (nullable UIImage *)decompressedImageWithImage:(nullable UIImage *)image data:(NSData * _Nullable * _Nonnull)data format:(SDImageFormat)format shouldScaleDown:(BOOL)shouldScaleDown;
- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format;

@end
