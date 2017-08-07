/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "NSData+ImageContentType.h"
#import "NSImage+WebCache.h"

/**
 Return the shared device-dependent RGB color space created with CGColorSpaceCreateDeviceRGB

 @return The device-dependent RGB color space
 */
CG_EXTERN CGColorSpaceRef _Nonnull SDCGColorSpaceGetDeviceRGB(void);

/**
 Check whether CGImageRef contains alpha channel

 @param imageRef The CGImageRef
 @return Return YES if CGImageRef contains alpha channel, otherwise return NO
 */
CG_EXTERN BOOL SDCGImageRefContainsAlpha(_Nullable CGImageRef imageRef);

@protocol SDWebImageCoder <NSObject>

@optional

/**
 Decode an data to image

 @param data The image data
 @param format The eetected image format
 @return The decoded image
 */
- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data format:(SDImageFormat)format;

/**
 <#Description#>

 @param data <#data description#>
 @param format <#format description#>
 @param finished <#finished description#>
 @return <#return value description#>
 */
- (nullable UIImage *)incrementalDecodedImageWithData:(nullable NSData *)data format:(SDImageFormat)format finished:(BOOL)finished;

/**
 <#Description#>

 @param image <#image description#>
 @param format <#format description#>
 @return <#return value description#>
 */
- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format;

@end
