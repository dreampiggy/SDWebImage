/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Matt Galloway
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDTestCase.h"
#import <SDWebImage/SDWebImageDecoder.h>
#import <SDWebImage/SDWebImageWebPCoder.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

@interface SDWebImageTestDecoder : NSObject <SDWebImageCoder>

@end

@implementation SDWebImageTestDecoder

- (UIImage *)decodedImageWithData:(NSData *)data format:(SDImageFormat)format {
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    return image;
}

- (UIImage *)incrementalDecodedImageWithData:(NSData *)data format:(SDImageFormat)format finished:(BOOL)finished {
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"gif"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    return image;
}

- (UIImage *)decompressedImageWithImage:(UIImage *)image data:(NSData *__autoreleasing  _Nullable *)data format:(SDImageFormat)format shouldScaleDown:(BOOL)shouldScaleDown {
    NSString *testString = @"TestDecompress";
    NSData *testData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    *data = testData;
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"png"];
    UIImage *testImage = [UIImage imageWithContentsOfFile:testImagePath];
    
    return testImage;
}

- (NSData *)encodedDataWithImage:(UIImage *)image format:(SDImageFormat)format {
    NSString *testString = @"TestEncode";
    NSData *data = [testString dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

@end

@interface SDWebImageDecoderTests : SDTestCase

@end

@implementation SDWebImageDecoderTests

- (void)test01ThatDecodedImageWithNilImageReturnsNil {
    expect([UIImage decodedImageWithImage:nil]).to.beNil();
}

- (void)test02ThatDecodedImageWithImageWorksWithARegularJPGImage {
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    UIImage *decodedImage = [UIImage decodedImageWithImage:image];
    expect(decodedImage).toNot.beNil();
    expect(decodedImage).toNot.equal(image);
    expect(decodedImage.size.width).to.equal(image.size.width);
    expect(decodedImage.size.height).to.equal(image.size.height);
}

- (void)test03ThatDecodedImageWithImageDoesNotDecodeAnimatedImages {
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"gif"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    UIImage *animatedImage = [UIImage animatedImageWithImages:@[image] duration:0];
    UIImage *decodedImage = [UIImage decodedImageWithImage:animatedImage];
    expect(decodedImage).toNot.beNil();
    expect(decodedImage).to.equal(animatedImage);
}

- (void)test04ThatDecodedImageWithImageDoesNotDecodeImagesWithAlpha {
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    UIImage *decodedImage = [UIImage decodedImageWithImage:image];
    expect(decodedImage).toNot.beNil();
    expect(decodedImage).to.equal(image);
}

- (void)test05ThatDecodedImageWithImageWorksEvenWithMonochromeImage {
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"MonochromeTestImage" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    UIImage *decodedImage = [UIImage decodedImageWithImage:image];
    expect(decodedImage).toNot.beNil();
    expect(decodedImage).toNot.equal(image);
    expect(decodedImage.size.width).to.equal(image.size.width);
    expect(decodedImage.size.height).to.equal(image.size.height);
}

- (void)test06ThatDecodeAndScaleDownImageWorks {
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImageLarge" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    UIImage *decodedImage = [UIImage decodedAndScaledDownImageWithImage:image];
    expect(decodedImage).toNot.beNil();
    expect(decodedImage).toNot.equal(image);
    expect(decodedImage.size.width).toNot.equal(image.size.width);
    expect(decodedImage.size.height).toNot.equal(image.size.height);
    expect(decodedImage.size.width * decodedImage.size.height).to.beLessThanOrEqualTo(60 * 1024 * 1024 / 4);    // how many pixels in 60 megs
}

- (void)test07ThatDecodeAndScaleDownImageDoesNotScaleSmallerImage {
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    UIImage *decodedImage = [UIImage decodedAndScaledDownImageWithImage:image];
    expect(decodedImage).toNot.beNil();
    expect(decodedImage).toNot.equal(image);
    expect(decodedImage.size.width).to.equal(image.size.width);
    expect(decodedImage.size.height).to.equal(image.size.height);
}

- (void)test08ThatStaticWebPCoderWorks {
    NSURL *staticWebPURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestImageStatic" withExtension:@"webp"];
    NSData *staticWebPData = [NSData dataWithContentsOfURL:staticWebPURL];
    UIImage *staticWebPImage = [[SDWebImageWebPCoder sharedCoder] decodedImageWithData:staticWebPData format:SDImageFormatWebP];
    expect(staticWebPImage).toNot.beNil();
    
    NSData *outputData = [[SDWebImageWebPCoder sharedCoder] encodedDataWithImage:staticWebPImage format:SDImageFormatWebP];
    expect(outputData).toNot.beNil();
}

- (void)test09ThatAnimatedWebPCoderWorks {
    NSURL *animatedWebPURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestImageAnimated" withExtension:@"webp"];
    NSData *animatedWebPData = [NSData dataWithContentsOfURL:animatedWebPURL];
    UIImage *animatedWebPImage = [[SDWebImageWebPCoder sharedCoder] decodedImageWithData:animatedWebPData format:SDImageFormatWebP];
    expect(animatedWebPImage).toNot.beNil();
    expect(animatedWebPImage.images.count).to.beGreaterThan(0);
    
    NSData *outputData = [[SDWebImageWebPCoder sharedCoder] encodedDataWithImage:animatedWebPImage format:SDImageFormatWebP];
    expect(outputData).toNot.beNil();
}

- (void)test10ThatCustomDecoderWorksForImageCache {
    SDImageCache *cache = [[SDImageCache alloc] initWithNamespace:@"TestDecode"];
    cache.imageCoder = [[SDWebImageTestDecoder alloc] init];
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:testImagePath];
    NSString *key = @"TestPNGImageEncodedToDataAndRetrieveToJPEG";
    
    dispatch_semaphore_t lock = dispatch_semaphore_create(0);
    [cache storeImage:image imageData:nil forKey:key toDisk:YES completion:^{
        [cache clearMemory];
        dispatch_semaphore_signal(lock);
    }];
    dispatch_semaphore_wait(lock, kAsyncTestTimeout);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL diskImageDataBySearchingAllPathsForKey = @selector(diskImageDataBySearchingAllPathsForKey:);
#pragma clang diagnostic pop
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSData *data = [cache performSelector:diskImageDataBySearchingAllPathsForKey withObject:key];
#pragma clang diagnostic pop
    NSString *str1 = @"TestEncode";
    NSString *str2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (![str1 isEqualToString:str2]) {
        XCTFail(@"Custom decoder not work for SDImageCache, check -[SDWebImageTestDecoder encodedDataWithImage:format:]");
    }
    
    UIImage *diskCacheImage = [cache imageFromDiskCacheForKey:key];
    
    NSString * decodedImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"png"];
    UIImage *testImage = [UIImage imageWithContentsOfFile:decodedImagePath];
    
    NSData *data1 = UIImagePNGRepresentation(testImage);
    NSData *data2 = UIImagePNGRepresentation(diskCacheImage);
    
    if (![data1 isEqualToData:data2]) {
        XCTFail(@"Custom decoder not work for SDImageCache, check -[SDWebImageTestDecoder decodedImageWithData:format:]");
    }
    
}

- (void)test11ThatCustomDeoderWorksForImageDownload {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Custom decoder not work for SDWebImageDownloader"];
    SDWebImageDownloader *downloader = [[SDWebImageDownloader alloc] init];
    downloader.imageCoder = [[SDWebImageTestDecoder alloc] init];
    NSURL * testImageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestImage" withExtension:@"png"];
    NSString * testImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImage" ofType:@"jpg"];
    UIImage *testImage = [UIImage imageWithContentsOfFile:testImagePath];
    
    [downloader downloadImageWithURL:testImageURL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        NSData *data1 = UIImagePNGRepresentation(testImage);
        NSData *data2 = UIImagePNGRepresentation(image);
        if (![data1 isEqualToData:data2]) {
            XCTFail(@"The image data is not equal to cutom decoder, check -[SDWebImageTestDecoder decodedImageWithData:format:]");
        }
        NSString *str1 = @"TestDecompress";
        NSString *str2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (![str1 isEqualToString:str2]) {
            XCTFail(@"The image data is not modified by the custom decoder, check -[SDWebImageTestDecoder decompressedImageWithImage:data:format:shouldScaleDown:]");
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithCommonTimeout];
}

@end
