//
//  SDAnimatedImagePlayer.h
//  SDWebImage
//
//  Created by lizhuoli on 2019/10/7.
//  Copyright © 2019 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDAnimatedImagePlayer : NSObject

- (instancetype)initWithProvider:(id<SDAnimatedImageProvider>)provider;

@property UIImage *currentFrame;
@property NSUInteger currentIndex;
@property NSUInteger currentLoopCount;

@property (nonatomic, copy) void (^onFrameChange)(NSUInteger index, UIImage *frame);
@property (nonatomic, copy) void (^onLoopEnd)(NSUInteger loopCount);
 
#pragma mark - Control

@property (readonly) BOOL isPlaying;

- (void)startPlaying;
- (void)pausePlaying;
- (void)stopPlaying;

@end

NS_ASSUME_NONNULL_END
