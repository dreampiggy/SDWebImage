/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+MultiFormat.h"
#import "SDWebImageDecoder.h"

@implementation UIImage (MultiFormat)

+ (nullable UIImage *)sd_imageWithData:(nullable NSData *)data {
    SDImageFormat format = [NSData sd_imageFormatForImageData:data];
    return [[SDWebImageDecoder sharedCoder] decodedImageWithData:data format:format];
}

- (nullable NSData *)sd_imageData {
    return [self sd_imageDataAsFormat:SDImageFormatUndefined];
}

- (nullable NSData *)sd_imageDataAsFormat:(SDImageFormat)imageFormat {
    NSData *imageData = nil;
    if (self) {
        imageData = [[SDWebImageDecoder sharedCoder] encodedDataWithImage:self format:imageFormat];
    }
    return imageData;
}


@end
