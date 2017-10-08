/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCoder.h"

@interface SDWebImageImageIOCoder : NSObject <SDWebImageCoder>

+ (nonnull instancetype)sharedCoder;
- (nullable UIImage *)incrementalDecodedImageWithData:(nullable NSData *)data format:(SDImageFormat)format finished:(BOOL)finished;

@end
