/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) james <https://github.com/mystcolor>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDecoder.h"
#import "SDWebImageImageIOCoder.h"
#import "SDWebImageGIFCoder.h"
#import "SDWebImageWebPCoder.h"

@interface SDWebImageDecoder ()

@property (nonatomic, strong) id<SDWebImageCoder> incrementalCoder;

@end

@implementation SDWebImageDecoder

+ (instancetype)sharedCoder {
    static SDWebImageDecoder *coder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coder = [[SDWebImageDecoder alloc] init];
    });
    return coder;
}

#pragma mark - Decode
- (UIImage *)decodedImageWithData:(NSData *)data format:(SDImageFormat)format {
    if (!data) {
        return nil;
    }
    
    UIImage *image;
    switch (format) {
        case SDImageFormatWebP:
#ifdef SD_WEBP
            image = [[SDWebImageWebPCoder sharedCoder] decodedImageWithData:data format:SDImageFormatWebP];
#endif
            break;
        case SDImageFormatGIF:
            image = [[SDWebImageGIFCoder sharedCoder] decodedImageWithData:data format:SDImageFormatGIF];
            break;
        default:
            image = [[SDWebImageImageIOCoder sharedCoder] decodedImageWithData:data format:format];
            break;
    }
    
    return image;
}

- (UIImage *)incrementalDecodedImageWithData:(NSData *)data format:(SDImageFormat)format finished:(BOOL)finished {
    NSAssert((self == [SDWebImageDecoder sharedCoder]), @"incremental decoding must be used on new alloced instance but not the shared instance");
    if (!data) {
        return nil;
    }
    
    switch (format) {
        case SDImageFormatWebP: {
#ifdef SD_WEBP
            if (!self.incrementalCoder) {
                self.incrementalCoder = [[SDWebImageWebPCoder alloc] init];
            }
#endif
        }
            break;
        default: {
            if (!self.incrementalCoder) {
                self.incrementalCoder = [[SDWebImageImageIOCoder alloc] init];
            }
        }
            break;
    }
    
    return [self.incrementalCoder incrementalDecodedImageWithData:data format:format finished:finished];
}

- (UIImage *)decompressedImageWithImage:(UIImage *)image data:(NSData *__autoreleasing  _Nullable *)data format:(SDImageFormat)format shouldScaleDown:(BOOL)shouldScaleDown {
    if (!image) {
        return nil;
    }
    
    UIImage *decompressedImage;
    switch (format) {
        case SDImageFormatWebP:
#if SD_WEBP
            decompressedImage = [[SDWebImageWebPCoder sharedCoder] decompressedImageWithImage:image data:data format:format shouldScaleDown:shouldScaleDown];
#endif
            break;
        case SDImageFormatGIF:
            decompressedImage = [[SDWebImageGIFCoder sharedCoder] decompressedImageWithImage:image data:data format:format shouldScaleDown:shouldScaleDown];
            break;
        default:
            decompressedImage = [[SDWebImageImageIOCoder sharedCoder] decompressedImageWithImage:image data:data format:format shouldScaleDown:shouldScaleDown];
            break;
    }
    
    return decompressedImage;
}

#pragma mark - Encode
- (NSData *)encodedDataWithImage:(UIImage *)image format:(SDImageFormat)format {
    if (!image) {
        return nil;
    }
    
    NSData *data;
    switch (format) {
        case SDImageFormatWebP:
#ifdef SD_WEBP
            data = [[SDWebImageWebPCoder sharedCoder] encodedDataWithImage:image format:SDImageFormatWebP];
#endif
            break;
        case SDImageFormatGIF:
            data = [[SDWebImageGIFCoder sharedCoder] encodedDataWithImage:image format:SDImageFormatGIF];
            break;
        default:
            data = [[SDWebImageImageIOCoder sharedCoder] encodedDataWithImage:image format:format];
            break;
    }
    
    return data;
}

@end
