/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDImageCoder.h"

NS_ASSUME_NONNULL_BEGIN

/***
 SDImagePDFKitCoder is a PDF image coder, which use the built-in UIKit/AppKit method to decode PDF images. And it will use the Core Graphics to draw PDF images when needed (For example, current firmware does not support built-in rendering). This class does not use PDFKit framwork because we focus on PDF vector images but not document pages rendering.
 
 @note For iOS/tvOS, from iOS/tvOS 11+, Apple support built-in vector scale for PDF image in `UIImage`. Which means you can just get set a image to the `UIImaegView`, then changing image view's bounds, contentMode to adjust the PDF image without losing any detail. However, when running on lower firmware, we don't support vector scaling and parse PDF image as a bitmap image. You can use `SDImageCoderDecodeThumnailPixelSize` and `SDWebImageContextImagePreserveAspectRatio` during image loading to specify a desired size (such as larger size for view rendering).
 @note For macOS, Apple support built-in vector scale for PDF image in `NSImage`. However, `NSImage` is mutable, you can change the size after image was loaded.
 @note By default we parse the first page (pageNumber = 1) of PDF image, for custom page number, check `SDWebImageContextPDFPageNumber` context option.
 @note If you call the coder directly, use the coder option (See `SDWebImagePDFCoderDefine.h`) instead of the context option.
 */
API_AVAILABLE(ios(11.0), macos(10.13))
@interface SDImagePDFKitCoder : NSObject <SDImageCoder>

@property (nonatomic, class, readonly) SDImagePDFKitCoder *sharedCoder;

@end

NS_ASSUME_NONNULL_END
