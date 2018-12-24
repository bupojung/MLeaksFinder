//
//  UIViewController+RxTracker.h
//  Pods-RxSwiftResourceTracker_Example
//
//  Created by bupozhuang on 2018/12/24.
//

#import <UIKit/UIKit.h>

extern const void *const kFromViewControllerNameKey;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RxTracker)
+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL;
- (NSString *)rxTracker_fromVCName;
- (void)checkResourcesAfterDealoc;
@end

NS_ASSUME_NONNULL_END
