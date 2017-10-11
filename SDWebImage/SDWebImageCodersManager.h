/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) james <https://github.com/mystcolor>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCoder.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^SDWebImageCodersConditionBlock)(id<SDWebImageCoder> coder);

@interface SDWebImageCodersManager : NSObject<SDWebImageCoder>

+ (nonnull instancetype)sharedInstance;

/**
 All coders in coders manager. The coders array is a priority queue, which means the later added coder will have the highest priority
 This property is resettable, means you can pass nil to set it to the default state. The getter method will never return nil
 */
@property (nonatomic, strong, readwrite, null_resettable) NSArray<SDWebImageCoder>* coders;

/**
 Add a new coder to the end of coders array. Which has the highest priority.

 @param coder coder
 */
- (void)addCoder:(nonnull id<SDWebImageCoder>)coder;

/**
 Remove a coder in the coders array.

 @param coder coder
 */
- (void)removeCoder:(nonnull id<SDWebImageCoder>)coder;

/**
 Return the coder pass the specify condition.

 @param conditionBlock Return YES to specify the current coder is chosen.
 @return The coder which pass the condition
 */
- (nullable id<SDWebImageCoder>)coderWithCondition:(SDWebImageCodersConditionBlock)conditionBlock;

@end

NS_ASSUME_NONNULL_END
