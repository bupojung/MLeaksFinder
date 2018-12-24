//
//  UINavigationController+RxTracker.m
//  Pods-RxSwiftResourceTracker_Example
//
//  Created by bupozhuang on 2018/12/24.
//

#import "UINavigationController+RxTracker.h"
#import <objc/runtime.h>
#import "UIViewController+RxTracker.h"
#import <RxSwiftResourceTracker/RxSwiftResourceTracker-Swift.h>

@implementation UINavigationController (RxTracker)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(pushViewController:animated:) withSEL:@selector(rxTracker_pushViewController:animated:)];
        [self swizzleSEL:@selector(popViewControllerAnimated:) withSEL:@selector(rxTracker_popViewControllerAnimated:)];
    });
}

- (void)rxTracker_pushViewController:(UIViewController *)viewController animated:(BOOL)animted {
    UIViewController *visibaleVC = self.visibleViewController;
    NSString *targetName = NSStringFromClass([viewController class]);
    NSString *curName = NSStringFromClass([visibaleVC class]);
    [[RxSwiftResources shared] trackWithCurVCName:curName targetVCName:targetName];
    [self rxTracker_pushViewController:viewController animated:animted];
}

- (UIViewController *)rxTracker_popViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedViewController = [self rxTracker_popViewControllerAnimated:animated];
    UIViewController *targetVC = poppedViewController;
    UIViewController *curVC = self.topViewController;
    if ([poppedViewController isKindOfClass:[UINavigationController class]]) {
        targetVC = ((UINavigationController *)poppedViewController).topViewController;
    }
    
    NSString *targetname = NSStringFromClass([targetVC class]);
    NSString *curName = NSStringFromClass([curVC class]);
    [[RxSwiftResources shared] assetResourceNotDeallocWithCurVCName:curName targetVCName:targetname];
    
    
    return poppedViewController;
}

- (NSArray<UIViewController *> *)rxTracker_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<UIViewController *> *poppedViewControllers = [self rxTracker_popToViewController:viewController animated:animated];
    UIViewController *curVC = self.topViewController;
    for (UIViewController *viewController in poppedViewControllers) {
        UIViewController *targetVC = viewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            targetVC = ((UINavigationController *)viewController).topViewController;
        }

        NSString *targetname = NSStringFromClass([targetVC class]);
        NSString *curName = NSStringFromClass([curVC class]);
        [[RxSwiftResources shared] assetResourceNotDeallocWithCurVCName:curName targetVCName:targetname];
    }
    
    return poppedViewControllers;
}

- (NSArray<UIViewController *> *)rxTracker_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<UIViewController *> *poppedViewControllers = [self rxTracker_popToRootViewControllerAnimated:animated];
    
    UIViewController *curVC = self.topViewController;
    for (UIViewController *viewController in poppedViewControllers) {
        UIViewController *targetVC = viewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            targetVC = ((UINavigationController *)viewController).topViewController;
        }

        
        NSString *targetname = NSStringFromClass([targetVC class]);
        NSString *curName = NSStringFromClass([curVC class]);
        [[RxSwiftResources shared] assetResourceNotDeallocWithCurVCName:curName targetVCName:targetname];
    }
    
    return poppedViewControllers;
}

@end
