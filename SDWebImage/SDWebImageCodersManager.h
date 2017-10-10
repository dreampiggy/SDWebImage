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

@interface SDWebImageCodersManager : NSObject<SDWebImageProgressiveCoder>

+ (nonnull instancetype)sharedInstance;

@property (nonatomic, strong, nonnull) NSArray<SDWebImageCoder>* coders;

- (void)addCoder:(nonnull id<SDWebImageCoder>)coder;
- (void)removeCoder:(nonnull id<SDWebImageCoder>)coder;

@end
