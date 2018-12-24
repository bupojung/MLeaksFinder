//
//  UIViewController+RxTracker.m
//  Pods-RxSwiftResourceTracker_Example
//
//  Created by bupozhuang on 2018/12/24.
//

#import "UIViewController+RxTracker.h"
#import <objc/runtime.h>
#import <RxSwiftResourceTracker/RxSwiftResourceTracker-Swift.h>

const void *const kFromViewControllerNameKey = &kFromViewControllerNameKey;

@implementation UIViewController (RxTracker)
+ (void)load {
    // swizzled
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(presentViewController:animated:completion:) withSEL:@selector(rxTracker_presentViewController:animted:completion:)];
        [self swizzleSEL:@selector(dismissViewControllerAnimated:completion:) withSEL:@selector(rxTracker_dismissViewControllerAnimated:completion:)];
    });
}

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)rxTracker_presentViewController:(UIViewController *) viewControllerToPresent animted:(BOOL) flag completion:(void (^)(void))completion {
    
    UIViewController *curVC = viewControllerToPresent;
    if (viewControllerToPresent.presentingViewController) {
        curVC = viewControllerToPresent.presentingViewController;
    }
    
    if ([curVC isKindOfClass:[UINavigationController class]]) {
        curVC = ((UINavigationController *)curVC).topViewController;
    }
    
    NSString *targetName = NSStringFromClass([curVC class]);
    NSString *curName = NSStringFromClass([self class]);
    
    [[RxSwiftResources shared] trackWithCurVCName:curName targetVCName:targetName];
    [self rxTracker_presentViewController:viewControllerToPresent animted:flag completion:completion];
    
}

- (void)rxTracker_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self rxTracker_dismissViewControllerAnimated:flag completion:completion];
    
    UIViewController *dismissedViewController = self.presentedViewController;
    if (!dismissedViewController && self.presentingViewController) {
        dismissedViewController = self;
    }
    
    if (!dismissedViewController) return;

    //TODO: CHECK FOR RESOURCES
    UIViewController *curVC = self;
    if (self.presentingViewController) {
        curVC = self.presentingViewController;
    }
    if ([curVC isKindOfClass:[UINavigationController class]]) {
        curVC = ((UINavigationController *)curVC).topViewController;
    }
    NSString *targetName = NSStringFromClass([dismissedViewController class]);
    NSString *curName = NSStringFromClass([curVC class]);

    [[RxSwiftResources shared] assetResourceNotDeallocWithCurVCName:curName targetVCName:targetName];
    
}

- (NSString *)rxTracker_fromVCName {
    return  objc_getAssociatedObject(self, kFromViewControllerNameKey);
}

- (void)checkResourcesAfterDealoc {
    
}
@end
