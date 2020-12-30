//
//  ScreenSaverManager.m
//  SumUp
//
//  Created by huy tran on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ScreenSaverManager.h"

@implementation ScreenSaverManager
@synthesize mainView;
+ (id)sharedManager {
    static ScreenSaverManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
  if (self = [super init]) {
    self.mainView = [[UIViewController alloc] init];
  }
  return self;
}
- (void)dealloc {
  // Should never be called, but just here for clarity really.
}
+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [ScreenSaverManager getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [ScreenSaverManager getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [ScreenSaverManager getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
+ (void)showModal {
   
}
@end
