/*
* This file is part of the SDWebImage package.
* (c) Olivier Poitrey <rs@dailymotion.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "SDImageCoder.h"

/// Animated image playback mode
typedef NS_ENUM(NSUInteger, SDAnimatedImagePlaybackMode) {
    /**
     * From first to last frame and stop or next loop.
     */
    SDAnimatedImagePlaybackModeNormal = 0,
    /**
     * From last frame to first frame and stop or next loop.
     */
    SDAnimatedImagePlaybackModeReverse,
    /**
     * From first frame to last frame and reverse again, like reciprocating.
     */
    SDAnimatedImagePlaybackModeBounce,
    /**
     * From last frame to first frame and reverse again, like reversed reciprocating.
     */
    SDAnimatedImagePlaybackModeReversedBounce,
};

typedef NS_ENUM(NSUInteger, SDAnimatedImageSynchronizationMode) {
    SDAnimatedImageSynchronizationModeNone = 0, // Do not sync to others, current coordinator internal status change
    SDAnimatedImageSynchronizationModeAll, // Sync to all other coordinators status immediately
    SDAnimatedImageSynchronizationModeLast, // Sync to all other coordinators status only when the last coordinator do the same action, like `stopPlaying` only when all coordinator stopped.
};

typedef void(^SDAnimatedImageFrameHandler)(NSUInteger index, UIImage * _Nonnull frame);
typedef void(^SDAnimatedImageLoopHandler)(NSUInteger loopCount);

@class SDAnimatedImagePlayer;
/// A coordinator to control the group player status changes. You can subclass this class and custom the behavior if you want.
/// When playing animated images in the same group, they'll share the same status changes like `frame index`, but some status like `pause/resume` will only be shared in some condition. For example, you may want `stop animation only when all view disappears`, and `start when any view appears`. This can be controlled by override the state control method.
@interface SDAnimatedImagePlayerCoordinator : NSObject

@property (nonatomic, weak, readonly, nullable) SDAnimatedImagePlayer *player;
/// Animation group tag name
@property (nonatomic, copy, readonly, nonnull) NSString *group;

/// Current frame index, zero based. This value is KVO Compliance.
@property (nonatomic, readonly) NSUInteger currentFrameIndex;

/// Current loop count since its latest animating. This value is KVO Compliance.
@property (nonatomic, readonly) NSUInteger currentLoopCount;

/// Seek to the desired frame index and loop count.
/// @note This can be used for advanced control like progressive loading, or skipping specify frames.
/// @param index The frame index
/// @param loopCount The loop count
- (void)seekToFrameAtIndex:(NSUInteger)index loopCount:(NSUInteger)loopCount  mode:(SDAnimatedImageSynchronizationMode)mode;

/// Return the status whether animation is playing.
@property (nonatomic, readonly, getter=isPlaying) BOOL playing;

/// Start the animation. Or resume the previously paused animation.
- (void)startPlayingWithMode:(SDAnimatedImageSynchronizationMode)mode;

/// Pause the animation. Keep the current frame index and loop count.
- (void)pausePlayingWithMode:(SDAnimatedImageSynchronizationMode)mode;

/// Stop the animation. Reset the current frame index and loop count.
- (void)stopPlayingWithMode:(SDAnimatedImageSynchronizationMode)mode;

/// Create coordinator using group tag
/// - Parameter group: The animation group tag
- (nonnull instancetype)initWithGroup:(nonnull NSString *)group;

@end

/// A player to control the playback of animated image, which can be used to drive Animated ImageView or any rendering usage, like CALayer/WatchKit/SwiftUI rendering.
@interface SDAnimatedImagePlayer : NSObject

/// Current playing frame image. This value is KVO Compliance.
@property (nonatomic, readonly, nullable) UIImage *currentFrame;

/// Current frame index, zero based. This value is KVO Compliance.
@property (nonatomic, readonly) NSUInteger currentFrameIndex;

/// Current loop count since its latest animating. This value is KVO Compliance.
@property (nonatomic, readonly) NSUInteger currentLoopCount;

/// Total frame count for animated image rendering. Defaults is animated image's frame count.
/// @note For progressive animation, you can update this value when your provider receive more frames.
@property (nonatomic, assign) NSUInteger totalFrameCount;

/// Total loop count for animated image rendering. Default is animated image's loop count.
@property (nonatomic, assign) NSUInteger totalLoopCount;

/// The animation playback rate. Default is 1.0
/// `1.0` means the normal speed.
/// `0.0` means stopping the animation.
/// `0.0-1.0` means the slow speed.
/// `> 1.0` means the fast speed.
/// `< 0.0` is not supported currently and stop animation. (may support reverse playback in the future)
@property (nonatomic, assign) double playbackRate;

/// Asynchronous setup animation playback mode. Default mode is SDAnimatedImagePlaybackModeNormal.
@property (nonatomic, assign) SDAnimatedImagePlaybackMode playbackMode;

/// Provide a max buffer size by bytes. This is used to adjust frame buffer count and can be useful when the decoding cost is expensive (such as Animated WebP software decoding). Default is 0.
/// `0` means automatically adjust by calculating current memory usage.
/// `1` means without any buffer cache, each of frames will be decoded and then be freed after rendering. (Lowest Memory and Highest CPU)
/// `NSUIntegerMax` means cache all the buffer. (Lowest CPU and Highest Memory)
@property (nonatomic, assign) NSUInteger maxBufferSize;

/// You can specify a runloop mode to let it rendering.
/// Default is NSRunLoopCommonModes on multi-core device, NSDefaultRunLoopMode on single-core device
@property (nonatomic, copy, nonnull) NSRunLoopMode runLoopMode;

/// Create a player with animated image provider. If the provider's `animatedImageFrameCount` is less than 1, returns nil.
/// The provider can be any protocol implementation, like `SDAnimatedImage`, `SDImageGIFCoder`, etc.
/// @note This provider can represent mutable content, like progressive animated loading. But you need to update the frame count by yourself
/// @param provider The animated provider
- (nullable instancetype)initWithProvider:(nonnull id<SDAnimatedImageProvider>)provider;

/// Create a player with animated image provider. If the provider's `animatedImageFrameCount` is less than 1, returns nil.
/// The provider can be any protocol implementation, like `SDAnimatedImage` or `SDImageGIFCoder`, etc.
/// @note This provider can represent mutable content, like progressive animated loading. But you need to update the frame count by yourself
/// @param provider The animated provider
+ (nullable instancetype)playerWithProvider:(nonnull id<SDAnimatedImageProvider>)provider;

/// Grab the shared player with the group and image provider. Only the when both provider and group are the same, will return the same player.
/// The player are weak referenced.
/// @param provider The animated provider
/// @param coordinator The animation coordinator
+ (nullable instancetype)sharedPlayerWithProvider:(nonnull id<SDAnimatedImageProvider>)provider coordinator:(nonnull SDAnimatedImagePlayerCoordinator *)coordinator;

/// The handler block when current frame and index changed.
/// @deprecated Use addAnimationFrameHandler to register handler, supports multi-broadcast
@property (nonatomic, copy, nullable) SDAnimatedImageFrameHandler animationFrameHandler API_DEPRECATED_WITH_REPLACEMENT("addAnimationFrameHandle:", macos(10.10, 10.10), ios(8.0, 8.0), tvos(9.0, 9.0), watchos(2.0, 2.0));

/// The handler block when one loop count finished.
/// @deprecated Use addAnimationLoopHandler to register handler, supports multi-broadcast
@property (nonatomic, copy, nullable) SDAnimatedImageLoopHandler animationLoopHandler API_DEPRECATED_WITH_REPLACEMENT("addAnimationLoopHandler:", macos(10.10, 10.10), ios(8.0, 8.0), tvos(9.0, 9.0), watchos(2.0, 2.0));

- (void)addAnimationFrameHandler:(nonnull SDAnimatedImageFrameHandler)handler;

- (void)addAnimationLoopHandler:(nonnull SDAnimatedImageLoopHandler)handler;

/// Return the status whether animation is playing.
@property (nonatomic, readonly, getter=isPlaying) BOOL playing;

/// Start the animation. Or resume the previously paused animation.
- (void)startPlaying;

/// Pause the animation. Keep the current frame index and loop count.
- (void)pausePlaying;

/// Stop the animation. Reset the current frame index and loop count.
- (void)stopPlaying;

/// Seek to the desired frame index and loop count.
/// @note This can be used for advanced control like progressive loading, or skipping specify frames.
/// @param index The frame index
/// @param loopCount The loop count
- (void)seekToFrameAtIndex:(NSUInteger)index loopCount:(NSUInteger)loopCount;

/// Clear the frame cache buffer. The frame cache buffer size can be controlled by `maxBufferSize`.
/// By default, when stop or pause the animation, the frame buffer is still kept to ready for the next restart
- (void)clearFrameBuffer;

@end
