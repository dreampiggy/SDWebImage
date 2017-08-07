/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#ifdef SD_WEBP

#import "UIImage+WebP.h"
#import "SDWebImageDecoder.h"

#import "objc/runtime.h"

@implementation UIImage (WebP)

- (NSInteger)sd_webpLoopCount
{
    NSNumber *value = objc_getAssociatedObject(self, @selector(sd_webpLoopCount));
    return value.integerValue;
}

+ (nullable UIImage *)sd_imageWithWebPData:(nullable NSData *)data {
    return [[SDWebImageDecoder sharedCoder] decodedImageWithData:data format:SDImageFormatWebP];
}

@end

#endif
