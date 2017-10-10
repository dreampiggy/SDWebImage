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


// The is the image coder protocol to provide custom image decoding/encoding
// All the method are called inside a dispatch queue and do not block main thread
@protocol SDWebImageCoder <NSObject>

/**
 Returns YES if this coder can decode some data. Otherwise, it should be passed to another coder
 
 @param data The image data so we can look at it
 @return YES if this coder can decode the data, NO otherwise
 */
- (BOOL)canDecodeData:(nullable NSData *)data;

/**
 Returns YES if this coder can encode some image. Otherwise, it should be passed to another coder
 
 @param format The image format
 @return YES if this coder can encode the image, NO otherwise
 */
- (BOOL)canEncodeImageFormat:(SDImageFormat)format;

/**
 Decode the image data to image.

 @param data The image data to be decoded
 @return The decoded image from data
 */
- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data;

/**
 Decompress the image with original image and image data

 @param image The original image to be decompressed
 @param data The pointer to original image data. The pointer itself is nonnull but image data can be null. This data will set to cache if needed. If you do not need to modify data at the sametime, ignore this param.
 @param shouldScaleDown return YES if `SDWebImageScaleDownLargeImages` was set, otherwise return NO
 @return The decompressed image
 */
- (nullable UIImage *)decompressedImageWithImage:(nullable UIImage *)image data:(NSData * _Nullable * _Nonnull)data shouldScaleDown:(BOOL)shouldScaleDown;

/**
 Encode the image to image data

 @param image The image to be encoded
 @param format The image format to encode, you should note `SDImageFormatUndefined` format is also  possible
 @return The encoded image data
 */
- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format;

@end

/// Using this protocol instead of an optional method inside `SDWebImageCoder`
@protocol SDWebImageProgressiveCoder <SDWebImageCoder>

/**
 Incremental(Progressive) decode the image data to image.
 
 @param data The image data has been downloaded so far
 @param finished Whether the download has finished
 @warning because incremental decoding need keep the data inside, we will alloc a new instance for each download operation to avoid conflicts
 @return The decoded image from data
 */
- (nullable UIImage *)incrementalDecodedImageWithData:(nullable NSData *)data finished:(BOOL)finished;

@end
