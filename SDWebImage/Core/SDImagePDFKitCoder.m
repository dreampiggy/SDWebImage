/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDImagePDFKitCoder.h"

#import <PDFKit/PDFKit.h>

@implementation SDImagePDFKitCoder

+ (SDImagePDFKitCoder *)sharedCoder {
    static dispatch_once_t onceToken;
    static SDImagePDFKitCoder *coder;
    dispatch_once(&onceToken, ^{
        coder = [[SDImagePDFKitCoder alloc] init];
    });
    return coder;
}

- (BOOL)canDecodeFromData:(NSData *)data {
    return [NSData sd_imageFormatForImageData:data] == SDImageFormatPDF;
}

- (UIImage *)decodedImageWithData:(NSData *)data options:(SDImageCoderOptions *)options {
    if (!data) {
        return nil;
    }
    
    PDFDocument *document = [[PDFDocument alloc] initWithData:data];
    if (!document) {
        return nil;
    }
    PDFPage *page = [document pageAtIndex:0];
    if (!page) {
        return nil;
    }
    
    CGRect boxRect = [page boundsForBox:kPDFDisplayBoxMediaBox];
    CGSize thumbnailSize = boxRect.size;
    
    return [page thumbnailOfSize:thumbnailSize forBox:kPDFDisplayBoxMediaBox];
//
//
//    let pageSize = page.bounds(for: .mediaBox)
//    let pdfScale = width / pageSize.width
//
//    // Apply if you're displaying the thumbnail on screen
//    let scale = UIScreen.main.scale * pdfScale
//    let screenSize = CGSize(width: pageSize.width * scale,
//                            height: pageSize.height * scale)
//
//    return page.thumbnail(of: screenSize, for: .mediaBox)

}


- (BOOL)canEncodeToFormat:(SDImageFormat)format {
    return format == SDImageFormatPDF;
}

- (NSData *)encodedDataWithImage:(UIImage *)image format:(SDImageFormat)format options:(SDImageCoderOptions *)options {
    return nil;
}

@end
