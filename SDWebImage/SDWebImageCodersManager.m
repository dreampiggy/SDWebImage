/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) james <https://github.com/mystcolor>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCodersManager.h"
#import "SDWebImageImageIOCoder.h"
#import "SDWebImageGIFCoder.h"
#ifdef SD_WEBP
#import "SDWebImageWebPCoder.h"
#endif

@interface SDWebImageCodersManager ()

@property (nonatomic, strong, nonnull) NSMutableArray<SDWebImageCoder>* mutableCoders;
@property (SDDispatchQueueSetterSementics, nonatomic, nullable) dispatch_queue_t mutableCodersAccessQueue;

@end

@implementation SDWebImageCodersManager

+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // initialize with default coders
        _mutableCoders = [@[[SDWebImageImageIOCoder sharedCoder], [SDWebImageGIFCoder sharedCoder]] mutableCopy];
#ifdef SD_WEBP
        [_mutableCoders addObject:[SDWebImageWebPCoder sharedCoder]];
#endif
        _mutableCodersAccessQueue = dispatch_queue_create("com.hackemist.SDWebImageCodersManager", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc {
    SDDispatchQueueRelease(_mutableCodersAccessQueue);
}

- (void)addCoder:(nonnull id<SDWebImageCoder>)coder {
    if ([coder conformsToProtocol:@protocol(SDWebImageCoder)]) {
        dispatch_barrier_sync(self.mutableCodersAccessQueue, ^{
            [self.mutableCoders addObject:coder];
        });
    }
}

- (void)removeCoder:(nonnull id<SDWebImageCoder>)coder {
    dispatch_barrier_sync(self.mutableCodersAccessQueue, ^{
        [self.mutableCoders removeObject:coder];
    });
}

- (NSArray<SDWebImageCoder> *)coders {
    __block NSArray<SDWebImageCoder> *sortedCoders = nil;
    dispatch_sync(self.mutableCodersAccessQueue, ^{
        sortedCoders = (NSArray<SDWebImageCoder> *)[[[self.mutableCoders copy] reverseObjectEnumerator] allObjects];
    });
    return sortedCoders;
}

- (void)setCoders:(NSArray<SDWebImageCoder> *)coders {
    dispatch_barrier_sync(self.mutableCodersAccessQueue, ^{
        self.mutableCoders = [coders mutableCopy];
    });
}

#pragma mark - SDWebImageCoder
- (BOOL)canDecodeData:(NSData *)data {
    for (id<SDWebImageCoder> coder in self.coders) {
        if ([coder canDecodeData:data]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canEncodeImageFormat:(SDImageFormat)format {
    for (id<SDWebImageCoder> coder in self.coders) {
        if ([coder canEncodeImageFormat:format]) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)decodedImageWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    for (id<SDWebImageCoder> coder in self.coders) {
        if ([coder canDecodeData:data]) {
            return [coder decodedImageWithData:data];
        }
    }
    return nil;
}

- (UIImage *)decompressedImageWithImage:(UIImage *)image data:(NSData *__autoreleasing  _Nullable *)data options:(nullable NSDictionary<NSString*, NSObject*>*)optionsDict {
    if (!image) {
        return nil;
    }
    for (id<SDWebImageCoder> coder in self.coders) {
        if ([coder canDecodeData:*data]) {
            return [coder decompressedImageWithImage:image data:data options:optionsDict];
        }
    }
    return nil;
}

- (NSData *)encodedDataWithImage:(UIImage *)image format:(SDImageFormat)format properties:(nullable NSDictionary *)properties {
    if (!image) {
        return nil;
    }
    for (id<SDWebImageCoder> coder in self.coders) {
        if ([coder canEncodeImageFormat:format]) {
            return [coder encodedDataWithImage:image format:format properties:properties];
        }
    }
    return nil;
}

- (nullable NSDictionary *)propertiesOfImageData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    
    for (id<SDWebImageCoder> coder in self.coders) {
        // we can use `canDecodeData` here since we are dealling with NSData, even though this is part of the encoding process
        if ([coder canDecodeData:data]) {
            return [coder propertiesOfImageData:data];
        }
    }
    return nil;
}

- (UIImage *)incrementalDecodedImageWithData:(NSData *)data finished:(BOOL)finished {
    if (!data) {
        return nil;
    }
    for (id<SDWebImageCoder> coder in self.coders) {
        if ([coder canDecodeData:data] && [coder conformsToProtocol:@protocol(SDWebImageProgressiveCoder)]) {
            id<SDWebImageProgressiveCoder> progressiveCoder = (id<SDWebImageProgressiveCoder>)coder;
            return [progressiveCoder incrementalDecodedImageWithData:data finished:finished];
        }
    }
    return nil;
}


@end
